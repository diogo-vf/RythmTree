class Utils
    def self.bson_doc_to_hash bson_doc
        hash = {}
        bson_doc.each{ |key, val|
            if val.is_a? BSON::Document
                hash[key.to_sym] = Utils.bson_doc_to_hash val
            elsif val.is_a? Array
                hash[key.to_sym] = Utils.bson_doc_to_array val
            else
                hash[key.to_sym] = val
            end
        }
        
        hash
    end
    def self.bson_doc_to_array bson_array
        array = []
        bson_array.each{ |val|
            if val.is_a? BSON::Document
                array.push Utils.bson_doc_to_hash val
            elsif val.is_a? Array
                array.push Utils.bson_doc_to_array val
            else
                array.push val
            end
        }

        array
    end
end