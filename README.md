# Decompetition Data

These are anonymized PostgreSQL dumps of the competition database.  A `serve.sh`
script is included for convenience; it makes the data available via a throw-away
Docker conainer.

```sh
./serve.sh data-2020.sql.gz
```

You can then access the data by connecting to the PostgreSQL server listening on
`localhost:5432` (use the `-p` flag on both `serve.sh` and `psql` to use another
port).

```sh
psql -h localhost -U postgres
```

The 2020 data dump  is based on a snapshot taken on December 10th, 2020, about a
month after the competition finished.  This was to give players time to complete
the follow-up survey. All users, teams, and submissions created after the end of
the competition have been removed.


## Tables

### Users

```
id            unique id for this user
name          username (sanitized)
team_id       team id
info_id       background survey id (if any)
admin         is this user an admin?
followup_id   followup survey id (if any)
```

### Teams

```
id            unique id for this team
name          team name (sanitized)
```

### Challenges

```
id            unique id for this challenge
name          challenge name
value         point value (100 - 500)
functions     functions to be diffed (space separated; supports globs)
language      source language (c / cpp / go / rust / swift)
*             a bunch of file paths used by the backend
              see the challenges repo for the actual files
```

### Submissions

The total scores used for the competition were calculated as:
- 20% `test_score`
- 60% `diff_score`
- 20% perfect match bonus (all or nothing)

```
id            unique id for this submission
challenge_id  challenge id
user_id       user id
team_id       team id
timestamp     time of submission
submission    submitted source code
test_score    fraction of unit tests passed (0.0 - 1.0)
diff_score    jaccard similarity of disassembly (0.0 - 1.0)
score         total (cumulative weighted) score (0.0 - 1.0)
```

### Infos

These background surveys were submitted immediately after user account creation,
before the competition started.  See the next section for how to interpret the
"magic" text values (Flask wouldn't let me use numbers in drop-downs).

```
id                    unique info id
security_involvement  see below
security_experience   years of security experience
reversing_experience  years of reversing experience
reversing_workload    see below
reversing_confidence  see below
reversing_difficulty  see below
codexp_*              coding experience by language (1 = beginner; 5 = expert)
revexp_*              reversing experience by language (1 = beginner; 5 = expert)
tool_*                typical use of various tools (1 = never; 2 = sometimes; 3 = often)
tool_other            text field to list any tools we missed
```

### Followups

These surveys were submitted after the competition finished.  They used the same
questions as the original surveys, except the tool questions were rephrased to
ask how much people used the tools _during_ the competition.


## Survey Key

### Security Involvement

What best describes your involvement in computer security?
- Hobbyist
- Student
- Researcher
- Professional
- Other

### Reversing Workload

How much of your paid time is spent reverse engineering?
- `none`  I'm not paid to reverse anything.
- `some`  A little bit of my workload is reversing.
- `half`  Around half of my workload is reversing.
- `most`  Most or all of my workload is reversing.

### Reversing Confidence

How much confidence do you have in your reversing skills?
- `none`  I have no idea what I'm doing.
- `some`  I'm still a beginner.
- `half`  I'm an average reverser.
- `lots`  I'm better than average.
- `yuge`  I am an expert.

### Reversing Difficulty

How difficult is completely recreating the source code of a small binary?
- Trivial
- Easy
- Moderate
- Difficult
- Impossible
