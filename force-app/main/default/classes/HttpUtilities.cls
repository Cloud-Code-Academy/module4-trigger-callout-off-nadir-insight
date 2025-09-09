public with sharing class HttpUtilities {
    public HttpUtilities() {}

    public static HttpResponse makeCallout(
        String method,
        String endpoint
    ) {
        return makeCallout(method, endpoint, null, null, 10000);
    }   

    /**
     * @description Static method to make external callouts
     * @param method The HTTP method
     * @param endpoint The target for the callout
     * @param payload The callout body
     * @param additionalHeaders HTTP headers
     * @param timeoutMS callout timeout
     * @return ExchangeRateWrapper The parsed wrapper instance
     */
    public static HttpResponse makeCallout(
        String method,
        String endpoint,
        String payload,
        Map<String, String> additionalHeaders,
        Integer timeoutMS
    ) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setTimeout(timeoutMS);
        req.setHeader('Content-Type', 'application/json');

        if (payload != null) {
            req.setBody(payload);
        }

        if (additionalHeaders != null) {
            for (String key : additionalHeaders.keySet()) {
                req.setHeader(key, additionalHeaders.get(key));
            }
        }

        try {
            Http http = new Http();
            HttpResponse response = http.send(req);

            Integer statusCode = response.getStatusCode();
            if (statusCode >= 200 && statusCode < 300) {
                return response;
            } else {
                System.debug('Callout failed. Status Code: ' + statusCode);
                System.debug('Response Body: ' + response.getBody());
                throw new CalloutException('Callout Error');
            }

        } catch (CalloutException ex) {
            System.debug('Callout Exception Error: ' + ex.getMessage());
            throw ex;
        }
    }
}