  # At https://www.pivotaltracker.com/projects/957456/integrations -> Activity Web Hook
class Receiver
  class PT
    def self.process(username, payload)
    end
  end
end

__END__
{
  "changes": [
    {
      "name": "[£35] Come up with name",
      "story_type": "feature",
      "new_values": {
        "requested_by_id": 48754,
        "updated_at": 1384513924000,
        "name": "[£35] Come up with name",
        "story_type": "feature",
        "id": 60839620,
        "created_at": 1384513924000,
        "label_ids": [

        ],
        "project_id": 957456,
        "follower_ids": [

        ],
        "current_state": "unscheduled",
        "labels": [

        ]
      },
      "id": 60839620,
      "kind": "story",
      "change_type": "create"
    }
  ],
  "message": "Jakub Stastny added this feature",
  "kind": "story_create_activity",
  "project": {
    "name": "Pay per task thingy",
    "id": 957456,
    "kind": "project"
  },
  "performed_by": {
    "name": "Jakub Stastny",
    "id": 48754,
    "kind": "person",
    "initials": "JS"
  },
  "occurred_at": 1384513924000,
  "guid": "957456_2",
  "project_version": 2,
  "primary_resources": [
    {
      "name": "[£35] Come up with name",
      "id": 60839620,
      "story_type": "feature",
      "kind": "story",
      "url": "http://www.pivotaltracker.com/story/show/60839620"
    }
  ],
  "highlight": "added"
}
