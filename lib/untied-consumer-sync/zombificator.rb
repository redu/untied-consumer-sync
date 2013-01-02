module Untied
  module Consumer
    module Sync
      module Zombificator
        module ActsAsZombie
          # Modulo que adiciona suporte a modelos zombies. Se um modelo for criado sem validação
          # ele automaticamente é marcado como zombie, caso a validação seja feita,
          # o modelo perde essa tag se não ocorrer nenhum erro.
          extend ActiveSupport::Concern

          included do
            attr_accessible :zombie

            # Modelos zombies não devem aparecer em consultas normais.
            default_scope where(:zombie => false)

            after_validation { self.zombie = false if self.errors.empty? }
          end
        end
      end
    end
  end
end
