require 'httparty'
require 'json'
require 'logger'

api_key = 'API-KEY-HERE'

# Setting the base url for the API
base_url = 'https://api.pagerduty.com'

# setting the headers
headers = {
 'Content-Type' => 'application/json',
 'Authorization' => "Token token=#{api_key}"
}

# create a log file to output the error/info response
$log = Logger.new("custom_field_#{Date.today}.log")

# options for field type single_value, single_value_fixed, multi_value, multi_value_fixed
custom_field_data = {
    field: {
        data_type: 'string',
        name: 'instance_environment',
        display_name: 'Instance Environment',
        description: 'The environment that the issue occurred in',
        field_type: 'single_value_fixed',
        default_value: 'production',
        field_options: [
            {
                data: {
                    data_type: 'string',
                    value: 'production'
                }
            },
            {
                data: {
                    data_type: 'string',
                    value: 'staging'
                }
            }
        ]
    }
}

# custom field method to create a new custom field
def post_custom_field(api_key, base_url, headers, custom_field_data)
  response = HTTParty.post("#{base_url}/incidents/custom_fields",
                           body: custom_field_data.to_json,
                           headers: headers)
  puts response.body
  if response.code == 201
    field = JSON.parse(response.body)
    puts "Successfully created custom field with name: #{field['field']['display_name']} and ID: #{field['field']['id']}"
    $log.info("Successfully created custom field with name: #{field['field']['display_name']} and ID: #{field['field']['id']}")
  else
    puts "Failed to create custom field: #{response.body}"
    $log.error("Failed to create custom field: #{response.body}")
    return nil
  end
end

# Call the method to create the custom field
post_custom_field(api_key, base_url, headers, custom_field_data)
