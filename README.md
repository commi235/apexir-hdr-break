APEX IR Column Headings with Line Breaks
========================================
Installation
------------
1. Import the included plugin file into your application.
2. Run the included SQL file in folder "server" to install the package. (optional)
3. Prefix the values in "Render Function Name" and "AJAX Function Name" with the package name. (optional)

Usage
-----
1. Create a dynamic action firing after refresh of an interactive report.
2. Select plugin as action and set affected elements to "Triggering Element" and leave "Fire on Page Load" set to "Yes".
3. Modify the column's single row headings the way you want them to be shown.

If you want to enable the plugin for all interactive reports in an application create the plugin on the global page.  
Set "Selection Type" to "jQuery Selector" and enter ".a-IRR" as selector.

How It Works
------------
The render function places some JavaScript on the page which calls the AJAX Callback and hands the result to another function.  
The AJAX Callback retrieves all single row column headings which differ from the standard headings for the affected interactive report and sends it back as an JSON-Object in following format:  
"Column ID": "Single Row Heading"  
The rendered function loops through the object and replaces the current column heading with the received value.
