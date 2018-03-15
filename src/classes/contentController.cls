public class contentController {
    
    public String imageUrl {get; set;}
    
    public contentController() {
        file = new ContentVersion();
        imageUrl = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=06828000000gPprAAE&operationContext=CHATTER';
    }
    
    public ContentVersion file { get; set; }
    
    public PageReference go() {
        file.title = 'test';
        insert file;
        return new PageReference('/' + file.id);
    }
}