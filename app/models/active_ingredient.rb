class ActiveIngredient < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  belongs_to :group
  has_many :medicine_active_ingredients
  has_many :medicines, through: :medicine_active_ingredients
  
  rails_admin do
    configure :medicine_active_ingredients do
      visible(false)
    end
  end
  
    # elastic
  settings index: {
#     number_of_shards: 1,
    analysis: { 
      filter: {
        trigram: {
          type: "nGram",
          min_gram: 3,
          max_gram: 20,
        }
      },
      analyzer: { 
        index_trigrams_analyzer: { 
          tokenizer: 'whitespace', 
          filter: ["lowercase", "trigram"],
          type: "custom"
        },
        search_trigrams_analyzer: {
          type: 'custom',
          tokenizer: 'whitespace',
          filter: ['lowercase', "trigram"]
        }
      }
      
    }
  }
  mappings do
    indexes :name, index_analyzer: 'index_trigrams_analyzer', search_analyzer: "search_trigrams_analyzer"
  end

  def as_indexed_json(options={})
    self.as_json(
      only: [:id, :name]
    )
  end
   
  def self.srh(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query:  query,
            fields: [ "name" ],
            type: "phrase_prefix",
            minimum_should_match: "50%"
          }
        }
      }
    )
  end
    
end

# Delete the previous articles index in Elasticsearch
ActiveIngredient.__elasticsearch__.client.indices.delete index: ActiveIngredient.index_name rescue nil
 
# Create the new index with the new mapping
ActiveIngredient.__elasticsearch__.client.indices.create \
  index: ActiveIngredient.index_name,
  body: { settings: ActiveIngredient.settings.to_hash, mappings: ActiveIngredient.mappings.to_hash }

ActiveIngredient.import(force: true)
