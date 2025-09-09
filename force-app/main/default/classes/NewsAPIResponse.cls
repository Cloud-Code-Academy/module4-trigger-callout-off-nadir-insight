/**
 * Wrapper class for parsing the NewsAPI response
 */
public class NewsAPIResponse {
    // TODO: Define fields to match the NewsAPI response structure
    public String status { get; set; }
    public Integer totalResults { get; set; }
    public List<Article> articles { get; set; }
    
    /**
     * Inner class representing a news article
     */
    public class Article {
        public Source source { get; set; }
        public String author { get; set; }
        public String title { get; set; }
        public String description { get; set; }
        public String url { get; set; }
        public String urlToImage { get; set; }
        public String publishedAt { get; set; }
        public String content { get; set; }
    }
    
    /**
     * Inner class representing a news source
     */
    public class Source {
        // TODO: Define source fields
        // Example fields:
        // public String id { get; set; }
        // public String name { get; set; }
        public String id { get; set; }
        public String name { get; set; }
    }

    public static Article fromJson(String jsonString) {
        return (Article) JSON.deserialize(jsonString, Article.Class);
    }
    
    /**
     * Static method to convert an API article to a Salesforce Article__c record
     * @param apiArticle The API article to convert
     * @return Article__c The Salesforce record
     */
    public static Article__c convertToSObject(Article apiArticle) {
        // TODO: Implement conversion from API article to Salesforce record
        // Consider:
        // - Generating a unique record name
        // - Setting article fields from the API response
        // - Handling content length limits if needed
        // - Handling date conversion
        Article__c articleRecord = new Article__c();
        articleRecord.Author__c = apiArticle.author;
        // articleRecord.Category__c = apiArticle.category; // part of request?
        articleRecord.Content__c = apiArticle.content;
        // articleRecord.Country__c = apiArticle.country; // part of request?
        articleRecord.Description__c = apiArticle.description;
        // articleRecord.News_Category__c = apiArticle.category; // how to differentiate from line 60 -> cust obj?
        articleRecord.Published_At__c = convertStringToDateTime(apiArticle.publishedAt);
        articleRecord.Source__c = apiArticle.source.name; // should this be id or name?
        articleRecord.Title__c = apiArticle.title;
        articleRecord.url__c = apiArticle.url;
        articleRecord.urlToImage__c = apiArticle.urlToImage;

        return articleRecord;
    }

    public static DateTime convertStringToDateTime(String dateString) {
        // TODO: Implement date conversion
        String normalizedString = dateString.substring(0, 23) + 'Z'; // 2025-08-24T00:07:23.816Z
        Datetime dt = Datetime.valueOfGmt(normalizedString.replace('T',' ').replace('Z',''));
        Datetime localDt = dt.addSeconds(UserInfo.getTimezone().getOffset(dt) / 1000);
        return localDt;
    }

    public static String trimToLength(String input, Integer maxLength) {
        if (input == null) {
            return null;
        }
        if (maxLength == null || maxLength <= 0) {
            return '';
        }
        return (input.length() > maxLength) 
            ? input.substring(0, maxLength) 
            : input;
    }

public static Integer getFieldMaxLength(String objectName, String fieldName) {
        try {
            // Describe the object
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe()
                .get(objectName)
                .getDescribe()
                .fields.getMap();

            if (fieldMap.containsKey(fieldName)) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
                return fieldDescribe.getLength(); // Returns max length for text-based fields
            } else {
                return -1; // Field not found
            }
        } catch (Exception e) {
            return -1; // Any unexpected error
        }
    }
} 