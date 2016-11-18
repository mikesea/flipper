# Flipper::Api

API for the [Flipper](https://github.com/jnunemaker/flipper) gem.

## Installation

Add this line to your application's Gemfile:

    gem 'flipper-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flipper-api

## Usage

`Flipper::Api` is a mountable application that can be included in your Rails/Ruby apps. In a Rails application, you can mount `Flipper::Api` to a route of your choice:

```ruby
# config/routes.rb
YourRailsApp::Application.routes.draw do
  mount Flipper::Api.app(flipper) => '/flipper-api'
end
```

For more advanced mounting techniques and for suggestions on how to mount in a non-Rails application, it is recommend that you review the [`Flipper::UI` usage documentation](https://github.com/jnunemaker/flipper/blob/master/docs/ui/README.md#usage) as the same approaches apply to `Flipper::Api`.

## Endpoints

**Note:** Example CURL requests below assume a mount point of `/flipper-api`.

### Get all features

**URL**

`GET /api/v1/features`

**Request**

```
curl http://example.com/flipper-api/api/v1/features
```

**Response**

Returns an array of feature objects:

```json
{
  "features": [
    {
      "key": "search",
      "state": "on",
      "gates": [
        {
          "key": "boolean",
          "name": "boolean",
          "value": false
        },
        {
          "key": "groups",
          "name": "group",
          "value": []
        },
        {
          "key": "actors",
          "name": "actor",
          "value": []
        },
        {
          "key": "percentage_of_actors",
          "name": "percentage_of_actors",
          "value": 0
        },
        {
          "key": "percentage_of_time",
          "name": "percentage_of_time",
          "value": 0
        }
      ]
    },
    {
      "key": "history",
      "state": "off",
      "gates": [
        {
          "key": "boolean",
          "name": "boolean",
          "value": false
        },
        {
          "key": "groups",
          "name": "group",
          "value": []
        },
        {
          "key": "actors",
          "name": "actor",
          "value": []
        },
        {
          "key": "percentage_of_actors",
          "name": "percentage_of_actors",
          "value": 0
        },
        {
          "key": "percentage_of_time",
          "name": "percentage_of_time",
          "value": 0
        }
      ]
    }
  ]
}
```

### Create a new feature

**URL**

`POST /api/v1/features`

**Parameters**

* `name` - The name of the feature (Recommended naming conventions: lower case, snake case, underscores over dashes. Good: foo_bar, foo. Bad: FooBar, Foo Bar, foo bar, foo-bar.)

**Request**

```
curl -X POST -d "name=reports" http://example.com/flipper-api/api/v1/features
```

**Response**

On successful creation, the API will respond with an empty JSON response.

### Retrieve a feature

**URL**

`GET /api/v1/features/{feature_name}`

**Parameters**

* `feature_name` - The name of the feature to retrieve

**Request**

```
curl http://example.com/flipper-api/api/v1/features/reports
```

**Response**

Returns an individual feature object:

```json
{
  "key": "search",
  "state": "off",
  "gates": [
    {
      "key": "boolean",
      "name": "boolean",
      "value": false
    },
    {
      "key": "groups",
      "name": "group",
      "value": []
    },
    {
      "key": "actors",
      "name": "actor",
      "value": []
    },
    {
      "key": "percentage_of_actors",
      "name": "percentage_of_actors",
      "value": 0
    },
    {
      "key": "percentage_of_time",
      "name": "percentage_of_time",
      "value": 0
    }
  ]
}
```

### Delete a feature

**URL**

`DELETE /api/v1/features/{feature_name}`

**Parameters**

* `feature_name` - The name of the feature to delete

**Request**

```
curl -X DELETE http://example.com/flipper-api/api/v1/features/reports
```

**Response**

Successful deletion of a feature will return a 204 No Content response.

## Gates

The API supports enabling / disabling any of the Flipper [gates](https://github.com/jnunemaker/flipper/blob/master/docs/Gates.md). Gate endpoints follow the url convention:

**enable**

`POST /api/v1/{feature_name}/{gate_name}`

**disable**

`DELETE /api/v1/{feature_name}/{gate_name}`

and on a succesful request return a 200 HTTP status and the feature object as the response body.

### Boolean enable a feature

**URL**

`POST /api/v1/features/{feature_name}/boolean`

**Parameters**

* `feature_name` - The name of the feature to enable

**Request**

```
curl -X POST http://example.com/flipper-api/api/v1/features/reports/boolean
```

**Response**

Successful enabling of the boolean gate will return a 200 HTTP status and the feature object as the response body.

```json
{
  "key": "reports",
  "state": "on",
  "gates": [
    {
      "key": "boolean",
      "name": "boolean",
      "value": true
    },
    {
      "key": "groups",
      "name": "group",
      "value": []
    },
    {
      "key": "actors",
      "name": "actor",
      "value": []
    },
    {
      "key": "percentage_of_actors",
      "name": "percentage_of_actors",
      "value": 0
    },
    {
      "key": "percentage_of_time",
      "name": "percentage_of_time",
      "value": 0
    }
  ]
}
```


### Boolean disable a feature

**URL**

`DELETE /api/v1/features/{feature_name}/boolean`

**Parameters**

* `feature_name` - The name of the feature to disable

**Request**

```
curl -X DELETE http://example.com/flipper-api/api/v1/features/reports/boolean
```

**Response**

Successful disabling of the boolean gate will return a 200 HTTP status and the feature object.

```json
{
  "key": "reports",
  "state": "off",
  "gates": [
    {
      "key": "boolean",
      "name": "boolean",
      "value": false
    },
    {
      "key": "groups",
      "name": "group",
      "value": []
    },
    {
      "key": "actors",
      "name": "actor",
      "value": []
    },
    {
      "key": "percentage_of_actors",
      "name": "percentage_of_actors",
      "value": 0
    },
    {
      "key": "percentage_of_time",
      "name": "percentage_of_time",
      "value": 0
    }
  ]
}
```

### Enable Group

**URL**

`POST /api/v1/features/{feature_name}/groups`

**Parameters**

* `feature_name` - The name of the feature

* `name` - The name of a registered group to enable

**Request**

```
curl -X POST -d "name=admins" http://example.com/flipper-api/api/v1/features/reports/groups
```

**Response**

Successful enabling of the group will return a 200 HTTP status and the feature object as the response body.

```json
{
  "key": "reports",
  "state": "conditional",
  "gates": [
    {
      "key": "boolean",
      "name": "boolean",
      "value": false
    },
    {
      "key": "groups",
      "name": "group",
      "value": ["admins"]
    },
    {
      "key": "actors",
      "name": "actor",
      "value": []
    },
    {
      "key": "percentage_of_actors",
      "name": "percentage_of_actors",
      "value": 0
    },
    {
      "key": "percentage_of_time",
      "name": "percentage_of_time",
      "value": 0
    }
  ]
}
```

### Disable Group

**URL**

`DELETE /api/v1/features/{feature_name}/groups`

**Parameters**

* `feature_name` - The name of the feature

* `name` - The name of a registered group to disable

**Request**

```
curl -X DELETE -d "name=admins" http://example.com/flipper-api/api/v1/features/reports/groups
```

**Response**

Successful disabling of the group will return a 200 HTTP status and the feature object as the response body.

```json
{
  "key": "reports",
  "state": "off",
  "gates": [
    {
      "key": "boolean",
      "name": "boolean",
      "value": false
    },
    {
      "key": "groups",
      "name": "group",
      "value": []
    },
    {
      "key": "actors",
      "name": "actor",
      "value": []
    },
    {
      "key": "percentage_of_actors",
      "name": "percentage_of_actors",
      "value": 0
    },
    {
      "key": "percentage_of_time",
      "name": "percentage_of_time",
      "value": 0
    }
  ]
}
```
### Enable Actor

**URL**

`POST /api/v1/features/{feature_name}/actors`

**Parameters**

* `feature_name` - The name of the feature

* `flipper_id` - The flipper_id of actor to enable

**Request**

```
curl -X POST -d "flipper_id=User:1" http://example.com/flipper-api/api/v1/features/reports/actors
```

**Response**

Successful enabling of the actor will return a 200 HTTP status and the feature object as the response body.

```json
{
  "key": "reports",
  "state": "conditional",
  "gates": [
    {
      "key": "boolean",
      "name": "boolean",
      "value": false
    },
    {
      "key": "groups",
      "name": "group",
      "value": []
    },
    {
      "key": "actors",
      "name": "actor",
      "value": ["User:1"]
    },
    {
      "key": "percentage_of_actors",
      "name": "percentage_of_actors",
      "value": 0
    },
    {
      "key": "percentage_of_time",
      "name": "percentage_of_time",
      "value": 0
    }
  ]
}
```
### Disable Actor

**URL**

`DELETE /api/v1/features/{feature_name}/actors`

**Parameters**

* `feature_name` - The name of the feature

* `flipper_id` - The flipper_id of actor to disable

**Request**

```
curl -X DELETE -d "flipper_id=User:1" http://example.com/flipper-api/api/v1/features/reports/actors
```

**Response**

Successful disabling of the actor will return a 200 HTTP status and the feature object as the response body.

```json
{
  "key": "reports",
  "state": "off",
  "gates": [
    {
      "key": "boolean",
      "name": "boolean",
      "value": false
    },
    {
      "key": "groups",
      "name": "group",
      "value": []
    },
    {
      "key": "actors",
      "name": "actor",
      "value": []
    },
    {
      "key": "percentage_of_actors",
      "name": "percentage_of_actors",
      "value": 0
    },
    {
      "key": "percentage_of_time",
      "name": "percentage_of_time",
      "value": 0
    }
  ]
}
```

### Enable Percentage of Actors

**URL**

`POST /api/v1/features/{feature_name}/percentage_of_actors`

**Parameters**

* `feature_name` - The name of the feature

* `percentage` - The percentage of actors to enable

**Request**

```
curl -X POST -d "percentage=20" http://example.com/flipper-api/api/v1/features/reports/percentage_of_actors
```

**Response**

Successful enabling of a percentage of actors will return a 200 HTTP status and the feature object as the response body.

```json
{
  "key": "reports",
  "state": "conditional",
  "gates": [
    {
      "key": "boolean",
      "name": "boolean",
      "value": false
    },
    {
      "key": "groups",
      "name": "group",
      "value": []
    },
    {
      "key": "actors",
      "name": "actor",
      "value": []
    },
    {
      "key": "percentage_of_actors",
      "name": "percentage_of_actors",
      "value": 20
    },
    {
      "key": "percentage_of_time",
      "name": "percentage_of_time",
      "value": 0
    }
  ]
}
```
### Disable Percentage of Actors

**URL**

`DELETE /api/v1/features/{feature_name}/percentage_of_actors`

**Parameters**

* `feature_name` - The name of the feature

**Request**

```
curl -X DELETE http://example.com/flipper-api/api/v1/features/reports/percentage_of_actors
```

**Response**

Successful disabling of a percentage of actors will set the percentage to 0 and return a 200 HTTP status and the feature object as the response body.

```json
{
  "key": "reports",
  "state": "off",
  "gates": [
    {
      "key": "boolean",
      "name": "boolean",
      "value": false
    },
    {
      "key": "groups",
      "name": "group",
      "value": []
    },
    {
      "key": "actors",
      "name": "actor",
      "value": []
    },
    {
      "key": "percentage_of_actors",
      "name": "percentage_of_actors",
      "value": 0
    },
    {
      "key": "percentage_of_time",
      "name": "percentage_of_time",
      "value": 0
    }
  ]
}
```
### Enable Percentage of Time

**URL**

`POST /api/v1/features/{feature_name}/percentage_of_time`

**Parameters**

* `feature_name` - The name of the feature

* `percentage` - The percentage of time to enable

**Request**

```
curl -X POST -d "percentage=20" http://example.com/flipper-api/api/v1/features/reports/percentage_of_time
```

**Response**

Successful enabling of a percentage of time will return a 200 HTTP status and the feature object as the response body.

```json
{
  "key": "reports",
  "state": "conditional",
  "gates": [
    {
      "key": "boolean",
      "name": "boolean",
      "value": false
    },
    {
      "key": "groups",
      "name": "group",
      "value": []
    },
    {
      "key": "actors",
      "name": "actor",
      "value": []
    },
    {
      "key": "percentage_of_actors",
      "name": "percentage_of_actors",
      "value": 0
    },
    {
      "key": "percentage_of_time",
      "name": "percentage_of_time",
      "value": 20
    }
  ]
}
```
### Disable Percentage of Time

**URL**

`DELETE /api/v1/features/{feature_name}/percentage_of_time`

**Parameters**

* `feature_name` - The name of the feature

**Request**

```
curl -X DELETE http://example.com/flipper-api/api/v1/features/reports/percentage_of_time
```

**Response**

Successful disabling of a percentage of time will set the percentage to 0 and return a 200 HTTP status and the feature object as the response body.

```json
{
  "key": "reports",
  "state": "off",
  "gates": [
    {
      "key": "boolean",
      "name": "boolean",
      "value": false
    },
    {
      "key": "groups",
      "name": "group",
      "value": []
    },
    {
      "key": "actors",
      "name": "actor",
      "value": []
    },
    {
      "key": "percentage_of_actors",
      "name": "percentage_of_actors",
      "value": 0
    },
    {
      "key": "percentage_of_time",
      "name": "percentage_of_time",
      "value": 0
    }
  ]
}
```

## Errors
In the event of an error the Flipper API will return an error object.  The error object will contain a Flipper-specific error code, an error message, and a link to the documentation for the given error code.

*example error object*
```json
{
    "code": 1,
    "message": "Feature not found",
    "more_info": "https://github.com/jnunemaker/flipper/...",
}
```

### Error Code Reference

#### 1: Feature Not Found

The requested feature does not exist.  Make sure the feature name is spelled correctly and exists in your application's database.

#### 2: Group Not Registered

The requested group specified by the `name` parameter is not registered.  Information on registering groups can be found in the [Gates documentation](https://github.com/jnunemaker/flipper/blob/master/docs/Gates.md).

#### 3: Percentage Invalid

The `percentage` parameter is invalid or missing.  `percentage` must be an integer between 0-100 inclusive and cannot be blank.

#### 4: Flipper ID Invalid

The `flipper_id` parameter is invalid or missing.  `flipper_id` cannot be empty.

####  5: Name Invalid
The `name` parameter is missing.  Make sure your request's body contains a `name` parameter.
