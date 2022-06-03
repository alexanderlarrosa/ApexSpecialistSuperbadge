public class WarehouseCalloutServiceMock implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest request) {
        String body = '[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"}]';
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'text-xml');
        response.setBody(body);
        response.setStatusCode(200);
        return response;
    }
}