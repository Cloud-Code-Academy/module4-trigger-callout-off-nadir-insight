// System.debug(NewsAPIResponse.getFieldMaxLength('Article__c', 'Description__c'));

// HttpResponse response = HttpUtilities.makeCallout('GET', 'callout:newsapi/v2/everything?q=soccer&pageSize=1');
HttpResponse response = HttpUtilities.makeCallout('GET', 'callout:newsapi/v2/everything?');
System.debug(response.getBody());