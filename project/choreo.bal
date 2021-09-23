import ballerinax/covid19;
import ballerina/log;
import ballerina/http;

service / on new http:Listener(8090) {
    resource function get country/[string country](http:Caller caller) returns error? {
        log:printInfo("Country"+country);
        covid19:Client covid19Endpoint = check new ();
        covid19:CovidCountry covidstats = check covid19Endpoint->getStatusByCountry("Country");
       json stats ={
       user_country:country,
       country:covidstats?.country?:"",
       total_cases:covidstats?.cases?:0.0
       };
       log:printInfo((stats).toString());
       check caller->respond(stats);
    }
}