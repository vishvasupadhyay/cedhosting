Feature: Incremental rebuild
  As an impatient hacker who likes to blog
  I want to be able to make a static site
  Without waiting too long for it to build

  Scenario: Produce correct output site
    Given I have a _layouts directory
    And I have a _posts directory
    And I have the following posts:
      | title    | date       | layout  | content                               |
      | Wargames | 2009-03-27 | default | The only winning move is not to play. |
    And I have a default layout that contains "Post Layout: {{ content }}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Post Layout: <p>The only winning move is not to play.</p>" in "_site/2009/03/27/wargames.html"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Post Layout: <p>The only winning move is not to play.</p>" in "_site/2009/03/27/wargames.html"

  Scenario: Generate a metadata file
    Given I have an "index.php" file that contains "Basic Site"
    When I run jekyll build
    Then the ".jekyll-metadata" file should exist

  Scenario: Rebuild when content is changed
    Given I have an "index.php" file that contains "Basic Site"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Basic Site" in "_site/index.php"
    When I wait 1 second
    Then I have an "index.php" file that contains "Bacon Site"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Bacon Site" in "_site/index.php"

  Scenario: Rebuild when layout is changed
    Given I have a _layouts directory
    And I have an "index.php" page with layout "default" that contains "Basic Site with Layout"
    And I have a default layout that contains "Page Layout: {{ content }}"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Page Layout: Basic Site with Layout" in "_site/index.php"
    When I wait 1 second
    Then I have a default layout that contains "Page Layout Changed: {{ content }}"
    When I run jekyll build --full-rebuild
    Then the _site directory should exist
    And I should see "Page Layout Changed: Basic Site with Layout" in "_site/index.php"

  Scenario: Rebuild when an include is changed
    Given I have a _includes directory
    And I have an "index.php" page that contains "Basic Site with include tag: {% include about.textile %}"
    And I have an "_includes/about.textile" file that contains "Generated by Jekyll"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Basic Site with include tag: Generated by Jekyll" in "_site/index.php"
    When I wait 1 second
    Then I have an "_includes/about.textile" file that contains "Regenerated by Jekyll"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Basic Site with include tag: Regenerated by Jekyll" in "_site/index.php"
