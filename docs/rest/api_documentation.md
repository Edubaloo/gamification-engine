# Gamification Engine API Documentation

This document provides a detailed overview of all REST API endpoints in the gamification engine, including request parameters and response data structures.

## Table of Contents

1. [User Management](#user-management)
   - [Add or Update Subject](#add-or-update-subject)
   - [Delete Subject](#delete-subject)
2. [Values and Progress](#values-and-progress)
   - [Increase Value](#increase-value)
   - [Increase Multiple Values](#increase-multiple-values)
   - [Get Progress](#get-progress)
   - [Get Achievement Level](#get-achievement-level)
   - [Achievement Goals and Level Progression](#achievement-goals-and-level-progression)
3. [Authentication](#authentication)
   - [Login](#login)
   - [Change Password](#change-password)
4. [Messaging and Devices](#messaging-and-devices)
   - [Register Device](#register-device)
   - [Get Messages](#get-messages)
   - [Set Messages Read](#set-messages-read)

## User Management

### Add or Update Subject

Adds or updates a subject (user) in the gamification system.

**Endpoint:** `POST /add_or_update_subject/{subjectId}`

**URL Parameters:**
- `subjectId` (integer): The ID of a subject in your system

**POST Parameters:**
- `lat` (float, optional): Latitude
- `lon` (float, optional): Longitude
- `country` (string, optional): Country
- `city` (string, optional): City
- `region` (string, optional): Region
- `friends` (string, optional): Comma separated list of user IDs
- `groups` (string, optional): Comma separated list of group IDs
- `language` (string, optional): Language name
- `name` (string, optional): **The name of the subject**
- `subjecttype_id` (integer, optional): **The ID of the subject type**
- `subjecttype` (string, optional): **The name of the subject type (alternative to subjecttype_id)**
- `additional_public_data` (JSON, optional): Additional public data

**Response:**
```json
{
  "status": "ok",
  "subject": {
    "id": 123,
    "name": "Subject Name",
    "subjecttype_id": 1,
    "lat": 47.123,
    "lng": 8.456,
    "timezone": "Europe/Zurich",
    "language_id": 1,
    "additional_public_data": {}
  }
}
```

### Delete Subject

Deletes a subject from the gamification system.

**Endpoint:** `DELETE /delete_subject/{subject_id}`

**URL Parameters:**
- `subject_id` (integer): The ID of the subject to delete

**Response:**
```json
{
  "status": "ok"
}
```

## Values and Progress

### Increase Value

Increases (or decreases) a value for a specific user.

**Endpoint:** `POST /increase_value/{variable_name}/{subject_id}/{key}`

**URL Parameters:**
- `variable_name` (string): The name of the variable to increase or decrease
- `subject_id` (integer): The ID of the subject
- `key` (string, optional): An optional key describing the context of the event

**POST Parameters:**
- `value` (float): The increase/decrease value

**Response:**
```json
{
  "achievements": [
    {
      "id": 123,
      "internal_name": "achievement_name",
      "level": 2,
      "new_levels": {
        "2": {
          "rewards": {
            "reward_id": {
              "id": 456,
              "reward_id": 789,
              "name": "reward_name",
              "value": "reward_value",
              "value_translated": "translated_value"
            }
            // Additional rewards...
          },
          "properties": {
            "property_id": {
              "property_id": 101,
              "name": "property_name",
              "value": "property_value",
              "value_translated": "translated_value"
            }
            // Additional properties...
          },
          "level": 2
        }
      }
    }
    // Additional achievements...
  ]
}
```

### Increase Multiple Values

Increases multiple values for multiple subjects in one request.

**Endpoint:** `POST /increase_multi_values`

**Request Body:**
```json
{
  "subject_id": {
    "variable_name": [
      {
        "key": "context_key",
        "value": 1.5
      }
    ]
  }
}
```

**Response:**
Same structure as [Increase Value](#increase-value)

### Get Progress

Get complete achievement progress for a single user.

**Endpoint:** `GET /progress/{subject_id}`

**URL Parameters:**
- `subject_id` (integer): The ID of the subject

**Query Parameters:**
- `achievement_id` (integer, optional): Filter by achievement ID 
- `achievement_history` (integer, optional): Number of historical entries to include (default: 2)

**Response:**
```json
{
  "achievements": [
    {
      "id": 123,
      "internal_name": "achievement_name",
      "view_permission": "everyone",
      "maxlevel": 5,
      "priority": 1,
      "hidden": false,
      "achievementcategory": "category_name",
      "level": 2,
      "levels_achieved": {
        "1": "2025-01-15T12:30:45Z",
        "2": "2025-02-20T10:15:30Z"
      },
      "progress": 75.5,
      "goal": {
        // Goal data
      },
      "leaderboard": [
        {
          "subject": {
            "id": 456,
            "name": "subject_name",
            "additional_public_data": {}
          },
          "value": 100.5,
          "position": 0
        },
        // Additional leaderboard entries...
      ],
      "leaderboard_position": 2,
      "achievement_date": {
        "from_date": "2025-02-01T00:00:00Z",
        "to_date": "2025-02-28T23:59:59Z"
      },
      "context_subject": {
        "id": 789,
        "name": "context_name",
        "additional_public_data": {}
      },
      "evaluation": "monthly",
      "evaluation_timezone": "UTC",
      "levels": {
        "1": {
          "level": 1,
          "goal": 50,
          "rewards": {
            // Rewards for level 1
          },
          "properties": {
            // Properties for level 1
          }
        },
        "2": {
          "level": 2,
          "goal": 100,
          "rewards": {
            // Rewards for level 2
          },
          "properties": {
            // Properties for level 2
          }
        }
        // Additional levels...
      }
    },
    // Additional achievements...
  ],
  "achievement_errors": [
    // Any errors that occurred during achievement evaluation
  ]
}
```

### Get Achievement Level

Get information about the rewards and properties of a specific achievement level.

**Endpoint:** `GET /achievement/{achievement_id}/level/{level}`

**URL Parameters:**
- `achievement_id` (integer): The ID of the achievement
- `level` (integer): The level to retrieve information for

**Response:**
```json
{
  "rewards": {
    "reward_id": {
      "id": 123,
      "reward_id": 456,
      "name": "reward_name",
      "value": "reward_value",
      "value_translated": "translated_value"
    },
    // Additional rewards...
  },
  "properties": {
    "property_id": {
      "property_id": 789,
      "name": "property_name",
      "value": "property_value",
      "value_translated": "translated_value"
    },
    // Additional properties...
  }
}
```

### Achievement Goals and Level Progression

The gamification engine supports defining dynamic goals for different achievement levels. Rather than having the same goal value for all levels, you can define expressions that calculate the goal based on the current level.

#### Goal Expressions

Goals are defined as string expressions in the `goal` field of the achievement. You can use the `level` variable within expressions to create progressively more challenging goals for higher levels.

**Example Goal Expressions:**

1. **Linear Growth**: `"100 * level"`
   - Level 1: Goal = 100
   - Level 2: Goal = 200
   - Level 3: Goal = 300

2. **Exponential Growth**: `"100 * (1.5^level)"`
   - Level 1: Goal = 100
   - Level 2: Goal = 150
   - Level 3: Goal = 225

3. **Quadratic Growth**: `"100 * (level^2)"`
   - Level 1: Goal = 100
   - Level 2: Goal = 400
   - Level 3: Goal = 900

These expressions allow you to design achievement systems where advancing from lower levels is easier, while higher levels require progressively more effort.

## Implementation Notes

This section provides details about the internal implementations of various API features.

### Subject Relationships

The gamification engine supports two types of subject relationships:

1. **Direct Relations (via `set_relations`)**
   - Used for friend-like relationships between subjects
   - Stored in the `subjectrelations` table
   - Creates directional relationships from one subject to others
   - Accessed through the `friends` parameter in the Add or Update Subject API

2. **Hierarchical Relations (via `set_parent_subjects`)**
   - Used for organizational/group membership relationships
   - Stored in the `subjects_subjects` table
   - Creates parent-child relationships between subjects
   - Accessed through the `groups` parameter in the Add or Update Subject API
   - Time-sensitive: tracks when subjects joined and left groups

### Subject Hierarchical Traversal

The gamification engine provides powerful methods to traverse subject hierarchies:

1. **get_ancestor_subjects**
   - Retrieves all parent subjects of a given subject
   - Can filter by subject type
   - Supports date-based filtering (e.g., only subjects that were members during a specific period)
   - Uses recursive SQL queries to efficiently traverse the hierarchy

2. **get_descendent_subjects**
   - Retrieves all child subjects of a given subject
   - Can filter by subject type
   - Supports the same date-based filtering as ancestor queries
   - Also uses recursive SQL queries for efficiency

These methods enable complex organizational structures and time-sensitive relationship tracking, which is essential for team-based achievements and organizational leaderboards.

### Achievement Domain and Comparison Logic

Achievements in the gamification engine can be constrained in two ways:

1. **Compared Subject Types (achievement_compared_subjects)**
   - Defines which subject types can be compared in leaderboards
   - Used to enable comparisons at different levels (individual, team, region, etc.)

2. **Domain Subjects (achievement_domain_subjects)**
   - Restricts the validity of achievements to specific subjects
   - For example, limiting an achievement to only be valid within a specific geographic region
   - Uses actual subject instances rather than subject types

The API uses these relationships to determine proper achievement context and leaderboard construction.

## Developer Reference

### Creating and Managing Subjects

When creating or updating subjects, it's essential to understand how the system handles identifiers and relationships:

#### Subject Creation Parameters

- **ID**: Required unique identifier (typically from your application's user system)
- **Name**: Optional friendly name for display purposes
- **SubjectType**: Either by ID (`subjecttype_id`) or name (`subjecttype`), determines the category of the subject
- **Location**: Optional lat/lng coordinates for geo-aware features
- **Language**: Optional language preference for localization
- **Timezone**: Used for time-aware features (defaults to UTC)
- **Additional Data**: JSON structure for custom application data

The `set_infos` method handles creating new subjects if they don't exist, making the Add or Update Subject API endpoint suitable for both creating and updating subjects.

#### Subject Identification and Default Values

When a subject is first created:
- If no subjecttype is specified, it defaults to "User" type if available, otherwise type ID 1
- Timezone defaults to UTC if not specified or invalid
- Name can be set during creation or in subsequent updates

The system is designed to gracefully handle missing information with sensible defaults while still allowing full customization when needed.

## Authentication

### Login

Authenticate a user.

**Endpoint:** `POST /auth/login`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password"
}
```

**Response:**
```json
{
  "token": "jwt_token_string"
}
```

### Change Password

Change a user's password.

**Endpoint:** `POST /auth/change_password`

**Headers:**
- `Authorization`: Bearer token

**Request Body:**
```json
{
  "old_password": "old_password",
  "new_password": "new_password"
}
```

**Response:**
```json
{
  "status": "ok"
}
```

## Messaging and Devices

### Register Device

Register a device for push notifications.

**Endpoint:** `POST /register_device/{subject_id}`

**URL Parameters:**
- `subject_id` (integer): The ID of the subject

**Request Body:**
```json
{
  "device_id": "device_unique_identifier",
  "push_id": "push_service_identifier",
  "device_os": "ios|android|other",
  "app_version": "1.0.0"
}
```

**Response:**
```json
{
  "status": "ok"
}
```

### Get Messages

Get messages for a user.

**Endpoint:** `GET /messages/{subject_id}`

**URL Parameters:**
- `subject_id` (integer): The ID of the subject

**Query Parameters:**
- `offset` (integer, optional): Pagination offset

**Response:**
```json
{
  "messages": [
    {
      "id": "message_id",
      "text": "Message text content",
      "is_read": false,
      "created_at": "2025-02-27T16:00:00Z"
    },
    // Additional messages...
  ]
}
```

### Set Messages Read

Mark messages as read.

**Endpoint:** `POST /read_messages/{subject_id}`

**URL Parameters:**
- `subject_id` (integer): The ID of the subject

**Request Body:**
```json
{
  "message_id": "message_id"
}
```

**Response:**
```json
{
  "status": "ok"
}
```

## Data Structure Details

### Leaderboard Structure

The leaderboard is returned as an array of objects in the following format:

```json
[
  {
    "subject": {
      "id": 123,
      "name": "subject_name",
      "additional_public_data": {}
    },
    "value": 100.5,
    "position": 0
  },
  {
    "subject": {
      "id": 456,
      "name": "other_subject",
      "additional_public_data": {}
    },
    "value": 75.3,
    "position": 1
  }
  // Additional entries...
]
```

Each leaderboard entry contains:
- `subject`: Basic information about the subject (user or group)
  - `id`: The subject's unique identifier
  - `name`: The subject's name
  - `additional_public_data`: Any additional public data associated with the subject
- `value`: The numeric value used for ranking in the leaderboard
- `position`: The zero-based position in the leaderboard (0 = first place)

The leaderboard is sorted by value in descending order, with higher values at the top.
