module Untied
  module Consumer
    module Sync
      module Backend
        module ActiveRecord
          class ModelHelper
            include Sync::Backend::Base

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
          end
        end
      end
    end
  end
end
