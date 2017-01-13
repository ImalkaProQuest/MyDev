public class DropboxController
{
    //Fetched from URL with test
    String code ;
    
    public DropboxController()
    {
        code = ApexPages.currentPage().getParameters().get('code') ;
        //Get the access token once we have code
        //if(code != '' && code != null)
        //{
            AccessToken() ;
        //}
    }
    
    public PageReference DropAuth()
    {
        //Authenticating
        PageReference pg = new PageReference('https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=3ksr5tibhvphzbq&redirect_uri=https://imallearn-dev-ed--c.ap2.visual.force.com/apex/DropboxPage') ;
        return pg ;
    }
    
    public void AccessToken()
    {
        Attachment att = [Select Id, Body, Name from Attachment Where Id = '00P2800000LK1mu'];
        string token = 'https://content.dropboxapi.com/1/files_put/auto/'+att.Name+'?overwrite=true';
//        String accesstoken = 'tW-8g3ledH4AAAAAAAAAtJIISChcm0SVecZ02ZCo0HwmpbFi10uJ3RiaeocgAK-b';
//String accesstoken = 's-WUxKtVeyAAAAAAAAAA4jpBrHb1QP8DUYxifwZrux2PpnVbGDKw0-5mRR0dktp-';
String accesstoken = 'tW-8g3ledH4AAAAAAAAAvCKdUYgFKuJq8BM5KKKhHDLK4dqjcWsPKPVNk6sbkQp-';
        HttpRequest r = new HttpRequest();
        r.setEndpoint(token);
        System.debug('***calloutUrl:'+token);
        r.setHeader('Authorization','Bearer ' +accesstoken);
        r.setBodyAsBlob(att.Body);
        r.setMethod('PUT');
        r.setTimeout(60000);
        Http h1 = new Http();
        HttpResponse res1 = h1.send(r);
        string resp1 = res1.getBody();
        System.debug(' Account Information :: ' + resp1);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(resp1);
        String sPath = (String)m.get('path');
        System.debug(' Path :: ' + sPath);
        
        String shareToken = 'https://api.dropboxapi.com/1/shares/auto/'+sPath+'?short_url=false';
        r = new HttpRequest();
        r.setEndpoint(shareToken);
        System.debug('***calloutUrl:'+shareToken);
        r.setHeader('Authorization','Bearer ' +accesstoken);
        r.setMethod('POST');
        r.setTimeout(60000);
        Http h2 = new Http();
        HttpResponse res2 = h2.send(r);
        string resp2 = res2.getBody();
        System.debug(' resp2 :: ' + resp2);
        
        /*string token = 'https://api.dropbox.com/1/account/info';
        HttpRequest r = new HttpRequest();
        r.setEndpoint(token);
        r.setHeader('Authorization','Bearer ' +accesstoken);
        r.setMethod('GET');
        r.setTimeout(60000);
        Http h1 = new Http();
        HttpResponse res1 = h1.send(r);
        string resp1 = res1.getBody();

        System.debug(' Account Information :: ' + resp1);
        /*String authriseUrl = 'https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=3ksr5tibhvphzbq&redirect_uri=https://imallearn-dev-ed--c.ap2.visual.force.com/apex/DropboxPage';
        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint(authriseUrl);
        req1.setMethod('GET');
        req1.setTimeout(60*1000);
        Http h1 = new Http();
        String resp1;
        HttpResponse res1 = h1.send(req1);
        resp1 = res1.getBody();
        System.debug('***resp1:'+resp1);
        
        //Getting access token from dropbox
        /*String tokenuri = 'https://api.dropbox.com/1/oauth2/token?grant_type=authorization_code&code='+code+'&redirect_uri=https://imallearn-dev-ed.my.salesforce.com/apex/DropboxPage'; 
        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenuri);
        req.setMethod('POST');
        req.setTimeout(60*1000);
          
        Blob headerValue = Blob.valueOf('3ksr5tibhvphzbq' + ':' + 'gn2u3mi9o01qsmp');
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        
        System.debug(' You can parse the response to get the access token ::: ' + resp);*/
   }
}