/**
 * Service class to interact with the NewsAPI for fetching top headlines
 */
public with sharing class NewsAPIService {
    // TODO: Define API endpoint constants
    private static final String API_NAMED_CREDENTIAL = 'callout:NewsAPI'; //https://newsapi.org
    private static final String API_ENDPOINT = '/v2/top-headlines';
    
    // TODO: Define default parameters
    private static final Integer PAGE_SIZE = 20; 
    
    /**
     * Fetches top headlines for a specified category with pagination support
     * @param category The news category (business, entertainment, general, health, science, sports, technology)
     * @param page Page number for pagination
     * @return NewsAPIResponse The wrapper object containing the API response
     */
    public static NewsAPIResponse getTopHeadlinesByCategory(String category, Integer page) {
        // TODO: Implement method to fetch headlines by category
        // - Validate parameters
        // - Build the request URL with fixed page size
        // - Make the callout
        // - Parse and return the response
        // GET https://newsapi.org/v2/top-headlines?country=us&apiKey=4c37a01724a2414eb4ed0062888d1148

        String categoryParameter = category == null ? '' : '&category=' + category;
        String pageParameter = page == null ? '?page=' + PAGE_SIZE : '?page=' + page;
        String endpointUrl = API_NAMED_CREDENTIAL + API_ENDPOINT + pageParameter + categoryParameter;
        HttpResponse response = HttpUtilities.makeCallout('GET', endpointUrl);
        
        NewsAPIResponse newsAPIResponse = parseResponse(response.getBody());
        return newsAPIResponse;
        // return response.getBody();
    }
    
    // duplicative of utility class
    /**
     * Helper method to make the HTTP callout
     * @param endpoint The full URL with parameters
     * @return HttpResponse The HTTP response
     */
    private static HttpResponse makeCallout(String endpoint) {
        // TODO: Implement HTTP callout
        // - Create and configure HTTP request
        // - Make the callout
        // - Handle exceptions
        
        return null;
    }
    
    /**
     * Helper method to parse the JSON response
     * @param jsonResponse The JSON response string
     * @return NewsAPIResponse The parsed response object
     */
    private static NewsAPIResponse parseResponse(String jsonResponse) {
        if (String.isBlank(jsonResponse)) {
            throw new IllegalArgumentException('JSON response cannot be null or empty.');
        }
        try {
            return (NewsAPIResponse) JSON.deserialize(jsonResponse, NewsAPIResponse.class);
        } catch (JSONException ex) {
            System.debug('JSON parsing error: ' + ex.getMessage());
            throw new NewsAPIException('Error parsing JSON response: ' + ex.getMessage());
        }
    }
    
    /**
     * Custom exception class for NewsAPI errors
     */
    public class NewsAPIException extends Exception {}
} 