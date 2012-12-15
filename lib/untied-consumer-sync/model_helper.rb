module Untied
  module Consumer
    module Sync
      class ModelHelper
        # Public: Lida com a manipulação dos modelos através de payloads.

        @@instances = {}

        def initialize(model_data)
          @model = model_data['name'].constantize
          @model_data = model_data
        end

        # Public: Procura o modelo pelo id.
        #
        # id - Inteiro que indentifica o objeto de acordo a configuração.
        #
        # Retorna o caso o modelo seja encontrado ou nil caso o modelo não exista
        # no banco.
        def find(id)
          # Unscoped para encontrar zombies
          @model.unscoped.send("find_by_#{@model_data['mappings']['id']}", id)
        end

        # Public: Cria um modelo zumbie temporário.
        #
        # id - Inteiro que indentifica o objeto de acordo com a configuração
        #
        # Retorna o modelo recém criado.
        def create_zombie(id)
          zombie = @model.new(@model_data['mappings']['id'] => id)
          zombie.save(:validate => false)

          zombie
        end

        # Public: Cria o modelo se o mesmo não existir no banco de dados.
        #
        # payload - Hash com os dados a serem inseridos.
        #
        # Retorna True se a operação for bem sucedida e False no caso contrário.
        def create_model(payload)
          temp_model = (find(payload[@model_data['mappings']['id']]) or @model.new)

          # Seta os atributos
          payload.each_pair { |key, value| temp_model.send("#{key.to_s}=", value) } if temp_model.zombie

          temp_model.save
        end

        # Public: Atualiza o modelo ou o cria se o mesmo não existir no banco.
        #
        # payload - Hash com os dados a serem inseridos.
        #
        # Retorna True se a operação for bem sucedida e False no caso contrário.
        def update_model(payload)
          temp_model = (find(payload[@model_data['mappings']['id']]) or @model.new)
          payload.each_pair {|key, value| temp_model.send("#{key.to_s}=", value)}

          temp_model.save
        end

        # Public: Destroi o modelo se o mesmo não existir no banco de dados.
        #
        # payload - Hash com os dados do modelo.
        #
        # Retorna True se a operação for bem sucedida e False no caso contrário.
        def destroy_model(payload)
          temp_model = find(payload[@model_data['mappings']['id']])

          temp_model.destroy if temp_model
        end

        def self.new(*args, &block)
          old_instance = @@instances[args[0]['name']]
          return old_instance if old_instance

          obj = ModelHelper.allocate
          obj.send(:initialize, *args, &block)
          @@instances[args[0]['name']] = obj

          obj
        end
      end
    end
  end
end
