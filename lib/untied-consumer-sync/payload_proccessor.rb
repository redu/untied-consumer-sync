module Untied
  module Consumer
    module Sync
      class PayloadProccessor
        # Public: Traduz payload recebido via Untied de acordo com os atributos e
        # mapeamentos do config/model_data.yml.

        @@instances = {}

        def initialize(model_data)
          @model_data = model_data
        end

        # Public: Faz o processamento geral da payload
        #
        # payload - Hash com os dados do modelo
        #
        # Retorna um novo Hash com os dados processados
        def proccess(payload)
          new_payload = slice_useless_attrs(payload)

          map_attrs(new_payload)
        end

        # Public: Metódo de conveniencia para checar as dependencias
        #
        # Retorna um Array com as dependencias presentes na configuração do modelo
        def dependencies
          @model_data.fetch('check_for', [])
        end

        def self.new(*args, &block)
          old_instance = @@instances[args[0]['name']]
          return old_instance if old_instance

          obj = PayloadProccessor.allocate
          obj.send(:initialize, *args, &block)
          @@instances[args[0]['name']] = obj
          obj
        end

        protected

        # Protected: Faz mapeamento de atributos
        #
        # payload - Hash com os dados do modelo
        #
        # Retorna um novo Hash com os atributos mapeados
        def map_attrs(payload)
          mappings = @model_data.fetch('mappings', {})

          mappings.each do |k, v|
            payload.merge!(v => payload.delete(k))
          end

          payload
        end

        # Protected: Remove atributos irrelevantes
        #
        # payload - Hash com os dados do modelo
        #
        # Retorna um novo Hash só com os atributos relevantes
        def slice_useless_attrs(payload)
          payload.reject do |key, value|
            !@model_data['attributes'].include?(key)
          end
        end
      end
    end
  end
end
