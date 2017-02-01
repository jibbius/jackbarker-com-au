@REM ------------
@REM Download updated versions JSON
@REM ------------
bitsadmin  /transfer mydownloadjob  /download  /priority normal https://pages.github.com/versions.json  %cd%\versions.json

@REM ------------
@REM Update bundles
@REM ------------
bundle update