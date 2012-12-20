require 'untied-consumer'

module Untied
  module Consumer
    module Sync
      class ObserverHelper < Untied::Consumer::Observer
        # Public:  Helper que lida com a logica de manipulção de modelos para o untied.
        # Observer do untied podem herdar dessa classe para adicionar os callbacks.

        # Public: Metódo proxy que abstrai a complexidade real do create.
        #
        # kind - String com o nome do modelo.
        # payload - Hash com os dados para a criação do modelo.
        #
        # Retorna True se a operação foi realizada com sucesso e False no caso
        # contrário.
        def create_proxy(kind, payload)
          call_method("create", kind, payload)
        end

        # Public: Metódo proxy que abstrai a complexidade real do update.
        #
        # kind - String com o nome do modelo.
        # payload - Hash com os dados para a criação do modelo.
        #
        # Retorna True se a operação foi realizada com sucesso e False no caso
        # contrário.
        def update_proxy(kind, payload)
          call_method("update", kind, payload)
        end

        # Public: Metódo proxy que abstrai a complexidade real do destroy.
        #
        # kind - String com o nome do modelo.
        # payload - Hash com os dados para a criação do modelo.
        #
        # Retorna True se a operação foi realizada com sucesso e False no caso.
        # contrário.
        def destroy_proxy(kind, payload)
          call_method("destroy", kind, payload)
        end

        # Public: Metódo para facilitar o acesso as configurações
        #
        # Retorna um Hash com as configurações dos modelos
        def config
          Sync.model_data
        end

        protected

        # Protected: Metodo auxiliar usado pelos proxies, codigo comum ao update, create
        # e destroy.
        #
        # method - String com o nome do metódo a ser chamado: create, update ou destroy.
        # kind - String com o nome do modelo.
        # payload - Hash com os dados para a criação do modelo.
        #
        # Retorna o True se a operação foi realizada com sucesso e False no caso
        # contrário.
        def call_method(method, kind, payload)
          model_data = config.fetch(kind.classify) {|k| raise "Kind #{k} not found in model_data.yml"}
          model_helper = Sync.backend.new(model_data)
          payload_proccessor = PayloadProccessor.new(model_data)
          new_payload = payload_proccessor.proccess(payload) #Remove dados inuteis

          self.send(method, new_payload, model_helper, payload_proccessor)
        end

        # Protected: Metódo que cria o modelo.
        #
        # payload - Hash com os dados para a criação do modelo.
        # model_helper - ModelHelper que lida com  a criação de modelos usando a payload.
        # payload_proccessor - PayloadProccessor que adequa a payload remota ao banco
        # local.
        #
        # Retorna True se a operação foi realizada com sucesso e False no caso.
        # contrário.
        def create(payload, model_helper, payload_proccessor)
          new_payload = create_dep(payload, payload_proccessor)

          model_helper.create_model(new_payload)
        end

        # Protected: Metódo que atauliza o modelo.
        #
        # payload - Hash com os dados para a criação do modelo.
        # model_helper - ModelHelper que lida com  a criação de modelos usando a payload.
        # payload_proccessor - PayloadProccessor que adequa a payload remota ao banco
        # local.
        #
        # Retorna True se a operação foi realizada com sucesso e False no caso.
        # contrário.
        def update(payload, model_helper, payload_proccessor)
          new_payload = create_dep(payload, payload_proccessor)

          model_helper.update_model(new_payload)
        end

        # Protected: Metódo que destroi o modelo.
        #
        # payload - Hash com os dados para a criação do modelo.
        # model_helper - ModelHelper que lida com  a criação de modelos usando a payload.
        # payload_proccessor - PayloadProccessor que adequa a payload remota ao banco
        # local.
        #
        # Retorna True se a operação foi realizada com sucesso e False no caso.
        # contrário.
        def destroy(payload, model_helper, payload_proccessor)
          model_helper.destroy_model(payload)
        end

        # Protected: Gera as dependencias para o modelo em questão, cria modelos zombies
        # se for necesário e traduz as referencias presentes no payload para
        # referencias locais.
        #
        # payload - Hash com os dados para a criação do modelo.
        # payload_proccessor - PayloadProccessor que adequa a payload remota ao banco
        # local.
        #
        # Retorna um Hash que representa a payload com as dependencias traduzidas
        def create_dep(payload, payload_proccessor)
          new_payload = payload.clone
          payload_proccessor.dependencies.each do |key, value|
            id = payload[value]
            aux_helper = Sync.backend.new(config[key.classify])
            modelo = (aux_helper.find(id) or aux_helper.create_zombie(id))
            new_payload.merge!(value => modelo.id)
          end

          new_payload
        end
      end
    end
  end
end
