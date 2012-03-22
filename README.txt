Demo web application that demonstrates having a page constantly check the
server for a new version of the page. The Last-Modified HTTP header is used
to determine the age of the document.

The algorithm passes the current modified date to the query string of the same
page and continuously polls the server until the modified date of th XHR
request is different from the request given in the query string.

The XHR requests are HTTP HEAD requests in an attempt to save bandwidth of the
entire document.

This code has been tested in chrome, the most recent version of firefox and
Internet Explorer 9.

Additional python libraries are required for the application server app.py.

To install them run
   $ easy_install mako webob paste pytz

Then start the application server
    $ python app.py

The application server listens on port 8000. To access if the application is
running on localhost visit http://localhost:8000 in a browser.

To demo the application, click the "Wait for content update" link. The
browser will continuously request the page behind the scenes.

Then edit and save the data.txt in the application directory. The browser
should render the new content and stop making backend requests.

The code has console logging in, so watch the requests and the date checking
in the console.log


