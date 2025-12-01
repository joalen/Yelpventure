defmodule LocalQuest.Yelp.Parser do
  def extract_businesses(yelp_response) do
    yelp_response
    |> get_in(["entities", Access.at(0), "businesses"])
    |> Enum.map(&format_for_unity/1)
  end

  defp format_for_unity(business) do
    %{
      id: business["id"],
      name: business["name"],
      coordinates: %{
        lat: get_in(business, ["coordinates", "latitude"]),
        lng: get_in(business, ["coordinates", "longitude"])
      },
      rating: business["rating"],
      review_count: business["review_count"],
      price: business["price"],
      categories: Enum.map(business["categories"], & &1["title"]),
      summary: get_in(business, ["summaries", "short"]),
      photo_url: get_in(business, ["contextual_info", "photos", Access.at(0), "original_url"]),
      yelp_url: business["url"]
    }
  end
end
