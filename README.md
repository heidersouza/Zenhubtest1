# Overview

This is a template repository.
Click `Use this template` to create a new repository from this one,
and use the new repo to simulate making structural changes to
course guide books.

## Initial Setup

YAML files located in the `dco` subdirectory define variables
that are used by the templates.  Most of these files are updated
from the content of a spreadsheet, but a few files are
independent of the spreadsheet:

* `dco/build.yml`: This file contains a few parameters that affect
  the rendering of templates.  In particular, you can control
  the directory where rendered templates are saved.  The default
  location is `./guides`, which stores the guide XML files in
  the normal location.  If you want to store template files in a
  different directoy, modify the `rendered_guides_dir` variable.
  Addtionally, the `in_development` variable describes if the
  course is still in development.  This controls the version
  number used in filenames for guides (Commit hash vs. version
  string).
* `dco/contributors.yml`: This file contains variables for the
  course authors, editors, and other contributors.  Modify
  this file to reflect the project contributors.  These values
  are used to generate the credits section of the guide
  front matter.

## Process

1. Create a copy of the spreadsheet:
   <https://docs.google.com/spreadsheets/d/13rGzAeC2m0q5JtTs48fmUBrUnAic-N22GASpjcpxm4w>
1. Modify the spreadsheet to describe the structure of the course.
1. Export the spreadsheet as "ODS", and save it to the root of
   your local clone of your (new) repository - as `dco.ods`.
1. Execute the `render-templates.sh` script. This will do
   three things:
   * autoupdate the `.pre-commit-dco-config.yaml` with new versions
     of the hook.
   * attempt to convert the DCO ODS file to YAML files under the
     `dco/` subdirectory.
   * render skeleton templates based on the data contained in the
     YAML files.
1. Execute a `git status`.
   * Carefully review the changes and/or new files under the
     `dco/` directory.  Make sure that the content of these files
     match the intended content contained in the spreadsheet.
   * If the YAML files in the `dco/` folder are okay, stage those
     files for the next commit: `git add dco/`.
     * If the files are not okay, determine if there is an error
       in the spreadsheet, or if the is an error with processing.
       Reach out to Dan if you have questions.
     * If the errors are due to the wrong content in the spreadsheet,
       start again at the second step.
   * After you stage the dco files, review the changes `guides/`
     directory.  Stage these files for the next commit.
1. Commit the ODS, YAML, and guides directory changes.
   Pre-commit runs the normal set of hooks.  It is likely that
   the normal hooks will "flag" something with the changes you've
   committed.  Review these warnings/errors, make appropriate changes,
   and re-commit.
