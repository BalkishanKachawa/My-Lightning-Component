public class MetadataContents implements Comparable {
        @AuraEnabled
        public String rev;
        @AuraEnabled
        public Boolean thumb_exists;
        @AuraEnabled
        public String path;        
        @AuraEnabled
        public Boolean is_dir;
        @AuraEnabled
        public String client_mtime;
        @AuraEnabled
        public String icon;
        @AuraEnabled
        public Boolean read_only;
        @AuraEnabled
        public Object modifier;
        @AuraEnabled
        public Integer bytes;
        @AuraEnabled
        public String modified;
        @AuraEnabled
        public String size;
        @AuraEnabled
        public String root;
        @AuraEnabled
        public String mime_type;
        @AuraEnabled
        public Integer revision;
        @AuraEnabled
        public String file_name;
        @AuraEnabled
        public String short_file_name;
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String content_hash;
        @AuraEnabled
        public String client_modified;
        @AuraEnabled
        public String server_modified;
        @AuraEnabled
        public String path_display;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String path_lower;
        @AuraEnabled
        public String tag;
        //@AuraEnabled
        //public MetadataContents[] contents{get;set;}
        
        public MetadataContents (String content_hash, String id, String client_modified, String rev, String server_modified, 
                                        String size, String path_display, string path_lower, String name, String tag){
            //this.read_only = read_only;
            //this.hash = hash;
            //this.revision = revision;
            this.rev = rev;
            //this.thumb_exists = thumb_exists;
            //this.bytes = bytes;
            modified = server_modified;
            path = path_display;
            file_name = name;
            //this.is_dir = is_dir;
            //this.icon = icon;
            //this.root = root;
            size = size;
            mime_type = name.subString(name.lastIndexOf('.'));
            //this.MetadataContents = new List<Contents>();
            
        }
        
        public Integer compareTo(Object is_dir) {
            MetadataContents container = (MetadataContents )is_dir;
            if (container.is_dir == true) return 1;
            if (container.is_dir == false) return 0;
            return -1;
        }
    /*
    public class MetadataContents implements Comparable {
        @AuraEnabled
        public String rev;
        @AuraEnabled
        public Boolean thumb_exists;
        @AuraEnabled
        public String path;        
        @AuraEnabled
        public Boolean is_dir;
        @AuraEnabled
        public String client_mtime;
        @AuraEnabled
        public String icon;
        @AuraEnabled
        public Boolean read_only;
        @AuraEnabled
        public Object modifier;
        @AuraEnabled
        public Integer bytes;
        @AuraEnabled
        public String modified;
        @AuraEnabled
        public String size;
        @AuraEnabled
        public String root;
        @AuraEnabled
        public String mime_type;
        @AuraEnabled
        public Integer revision;
        @AuraEnabled
        public String file_name{get;set;}
        @AuraEnabled
        public String short_file_name{get;set;}
        //@AuraEnabled
        //public MetadataContents[] contents{get;set;}
        
        public MetadataContents (Boolean read_only, Integer revision, Integer bytes, Boolean thumb_exists, String rev, String modified, 
                                        String size, String path, Boolean is_dir, String root, String icon){
            this.read_only = read_only;
            //this.hash = hash;
            this.revision = revision;
            this.rev = rev;
            this.thumb_exists = thumb_exists;
            this.bytes = bytes;
            this.modified = modified;
            this.path = path;
            this.file_name = path;
            this.is_dir = is_dir;
            this.icon = icon;
            this.root = root;
            this.size = size;
            this.mime_type = mime_type;
            //this.MetadataContents = new List<Contents>();
        }
        
        public Integer compareTo(Object is_dir) {
            MetadataContents container = (MetadataContents )is_dir;
            if (container.is_dir == true) return 1;
            if (container.is_dir == false) return 0;
            return -1;
        }
        
    }
    */        
}