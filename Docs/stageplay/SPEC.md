# .stageplay file (version 1)

The stageplay file format is a zip archive containing the following files:

## manifest.xml
Every `stageplay` file must contain a manifest.xml file at the root of the archive.

The file must be a well-formatted XML 1.1 document with UTF-8 encoding. It must have the `stageplay` element at its root with the `version` attribute.

### Structure
```xml
<?xml version="1.1" encoding="UTF-8" ?>
<stageplay version="1">
    <id>(uuid)</id>

    <dates>
        <created>(timestamp)</created>
        <modified>(timestamp)</modified>
    </dates>

    <document>
        <title>(string)</title>
        <author>(string?)</auvthor>

        <paths>
            <characters>(file path)</characters>
            <script>(file path)</script>
        </paths>
    </document>
</stageplay>
```

## characters.xml
The characters file contains all characters that are referenced within the script.

The file must be a well-formatted XML 1.1 document with UTF-8 encoding. It must have the `characters` element at its root.

### Structure
```xml
<?xml version="1.1" encoding="UTF-8" ?>
<characters>
    <character>
        <id>(uuid)</id>
        <name>(string)</name>
        <alias>(string?)</alias>
        <bio>
            (string)
        </bio>
    </character>
    (...)
</characters>
```