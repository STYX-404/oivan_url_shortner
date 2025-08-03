# URL Shortener API

A simple and efficient URL shortening service built with Ruby on Rails. This API allows you to create short URLs from long URLs and decode them back to their original form.

## Features

- **URL Encoding**: Convert long URLs into short, shareable links
- **URL Decoding**: Retrieve original URLs from short URLs
- **RESTful API**: Clean, intuitive API endpoints
- **Swagger Documentation**: Interactive API documentation
- **Collision Handling**: Robust collision detection and resolution
- **Validation**: Comprehensive URL validation

## Tech Stack

- **Ruby**: 3.2.0
- **Rails**: 7.1.0
- **Database**: Postgresql
- **API Documentation**: Rswag (Swagger/OpenAPI)
- **Testing**: RSpec with FactoryBot

## Prerequisites

Before running this project locally, ensure you have the following installed:

- Docker
- Ruby 3.2.0

## Local Development Setup

#### 1. Clone the Repository

```bash
git clone <repository-url>
cd oivan_url_shortner
```

#### 2. Build and Run with Docker

```bash
docker compose up --build
```

The application will be available at `http://localhost:3000`

#### 3. Access API Documentation

Visit `http://localhost:3000/api-docs` to access the interactive Swagger documentation.

#### 4. Configure Environment

I committed the `development.key` only to be able to run the project locally on you machine without the need to add it in the documentation

The application will be available at `http://localhost:3000`

#### 6. Access API Documentation

Visit `http://localhost:3000/api-docs` to access the interactive Swagger documentation.

## API Endpoints

### Encode URL
**POST** `/api/v1/urls/encode`

Creates a short URL from a long URL.

**Request Body:**
```json
{
  "url": {
    "original_url": "https://example.com/very/long/url/that/needs/shortening"
  }
}
```

**Response:**
```json
{
  "short_url": "http://localhost:3000/abc12345"
}
```

### Decode URL
**GET** `/api/v1/urls/decode?short_url=<short_url>`

Retrieves the original URL from a short URL.

**Response:**
```json
{
  "original_url": "https://example.com/very/long/url/that/needs/shortening"
}
```

### Redirect
**GET** `/<short_code>`

Directly redirects to the original URL when accessing a short URL in the browser.

## Testing

Run the test suite:

```bash
bundle exec rspec
```

## Deployed Demo

### Swagger Documentation
Access the live API documentation at: [https://oivan-url-shortner.onrender.com/api-docs/index.html]

## Scaling Considerations

### Collision Problem and Solution

The current implementation addresses the collision problem through several strategies:

#### 1. **Random Length Generation**
```ruby
uniq_key = SecureRandom.urlsafe_base64(rand(2..10))
```
- Uses variable length keys (2-10 characters)
- Reduces collision probability significantly

#### 2. **Collision Detection and Retry**
```ruby
loop do
  uniq_key = SecureRandom.urlsafe_base64(rand(2..10))
  short_url = "#{Rails.application.credentials[:domain_url]}/#{uniq_key}"
  return short_url unless Url.exists?(short_url:)
end
```
- Checks for existing URLs before returning
- Automatically retries on collision
- Ensures uniqueness at the database level

#### 3. **Database Constraints**
- Unique constraint on `short_url` field
- Database-level collision prevention

### Future Scaling Improvements

#### 1. **Caching Strategy**
- **Redis Caching**
```ruby
def generate_short_url
  Redis.fetch("#{original_url}", expires_in: 1.hour) do
  end
end
```

#### 2. **Database Optimization**
- **Indexing**: Ensure proper indexes on `short_url` and `original_url`
- **Read Replicas**: Separate read/write operations

#### 3. **Load Balancing**
- **Horizontal Scaling**: Multiple application instances
- **Rate Limiting**: Prevent abuse and ensure fair usage

#### 4. **Monitoring and Analytics**
- **Collision Metrics**: Track collision frequency
- **Performance Monitoring**: Response time and throughput
- **Usage Analytics**: Popular URLs and traffic patterns

### Performance Characteristics

- **Key Space**: With 2-10 character keys using base64, we have approximately 64^2 to 64^10 possible combinations
- **Collision Probability**: Extremely low due to random generation and retry mechanism

## Security Vulnerabilities and Solutions

### 1. Open Redirect Vulnerability

**Risk**: The application allows redirecting to any external URL without validation, enabling phishing attacks and potential data exfiltration. Attackers could create short URLs that redirect users to malicious sites designed to steal credentials or personal information.

**Solution**: Implement URL validation and domain whitelisting to ensure redirects only go to trusted domains. This prevents attackers from using the URL shortener as a proxy for malicious redirects.

### 2. No Authentication/Authorization

**Risk**: The API is completely open with no authentication, allowing anyone to create unlimited short URLs, access all URL mappings, and potentially abuse the service. This could lead to spam, resource exhaustion, and unauthorized access to URL data.

**Solution**: Implement API key authentication or JWT tokens to control access to the URL shortening service. This ensures only authorized users can create and manage short URLs.

### 3. Missing Rate Limiting

**Risk**: Without rate limiting, the service is vulnerable to abuse and potential DoS attacks. Malicious actors could overwhelm the system with requests, making it unavailable for legitimate users.

**Solution**: Implement rate limiting to restrict the number of requests per user or IP address within a specific time period. This prevents abuse while ensuring fair usage for all users.

### 4. CORS Configuration Issues

**Risk**: Cross-Origin Resource Sharing (CORS) is not properly configured, which could cause issues in production environments and potentially expose the API to unauthorized cross-origin requests.

**Solution**: Configure CORS properly to specify which origins are allowed to access the API. This prevents unauthorized domains from making requests to the URL shortening service.
