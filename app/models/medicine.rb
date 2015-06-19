require 'elasticsearch/model'

class Medicine < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include Filterable
  
  has_many :medicine_forms, dependent: :delete_all
  has_many :forms, through: :medicine_forms
  has_many :medicine_active_ingredients, dependent: :delete_all
  has_many :active_ingredients, through: :medicine_active_ingredients
  has_many :medicine_diseases
  has_many :diseases, through: :medicine_diseases
  has_many :reviews, as: :reviewable
  
  scope :forms, -> (form_ids) {
    forms = form_ids.map(&:to_i).join(",")
    Rails.logger.info("PARAMS: #{form_ids.count}")
  joins(:medicine_forms).where("medicine_forms.form_id in (#{forms})").group('medicine_id').having('count(*) = ?', form_ids.count)

#     joins(:medicine_forms).where(medicine_forms: {form_id: forms})
  }
  scope :groups, -> (group_id) { joins(active_ingredients: :group).where("groups.id = #{group_id}") }
  
  rails_admin do
    field :name
    field :diseases
    field :forms
    field :active_ingredients
    edit do
      field :description, :ck_editor
    end
    configure :medicine_forms do
      visible(false)
    end
    configure :medicine_active_ingredients do
      visible(false)
    end
    configure :medicine_diseases do
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
    indexes :active_ingredients, :type => "object", include_in_parent: true do
      indexes :name, index_analyzer: 'index_trigrams_analyzer', search_analyzer: "search_trigrams_analyzer"
    end
  end

  def as_indexed_json(options={})
    self.as_json(
      only: [:id, :name],
      include: {active_ingredients: {only: :name}
    })
  end
  
  def self.srh(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query:  query,
            fields: [ "name", "active_ingredients.name" ],
            type: "phrase_prefix",
            minimum_should_match: "50%"
          }
        }
        
#         query: { 
#           query_string: {
#             fields: ["name"],
#             query: query
#           } 
#         }

        
        
        
        
#           filtered: {
#             query: {
#               "match_all": {}
#             }
#           }
        }
    )
  end
  
  
end

# Delete the previous articles index in Elasticsearch
Medicine.__elasticsearch__.client.indices.delete index: Medicine.index_name rescue nil
 
# Create the new index with the new mapping
Medicine.__elasticsearch__.client.indices.create \
  index: Medicine.index_name,
  body: { settings: Medicine.settings.to_hash, mappings: Medicine.mappings.to_hash }

Medicine.import(force: true)