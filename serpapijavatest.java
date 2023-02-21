Map<String, String> parameter = new HashMap<>();

parameter.put("engine", "google_events");
parameter.put("q", "Events in Santa Cruz");
parameter.put("hl", "en");
parameter.put("gl", "us");
parameter.put("api_key", "2d9bc81791d55f47f0dd53bf219b0dbcad961b82afddc3502f8adf0b876bbbdb");

GoogleSearch search = new GoogleSearch(parameter);

try
{
  JsonObject results = search.getJson();
  var events_results = results.get("events_results");
}
catch (SerpApiClientException ex)
{
  Console.WriteLine("Exception:");
  Console.WriteLine(ex.ToString());
}