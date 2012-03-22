<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  </head>

  <body>
  <code><pre>${data}</pre></code>
  <div><a href='/' id='waitLink'>Wait for content update</a></div> 

  <script src='https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.js' type='text/javascript'></script>
  <script type='text/javascript'>
    // In case the browser doesn't have console.log
    if (typeof(window.console) == "undefined") { console = {}; console.log = console.warn = console.error = function(a) {}; }

    $(document).ready(function() {
        setWaitLinkHref();
        console.log("staleModifiedDate()", staleModifiedDate());
        console.log("docLastModified()", docLastModified());
        if(docLastModified() == staleModifiedDate()) {
            loadNewerVersion();
        }
    });

    function setWaitLinkHref() {
        $("#waitLink").attr("href", "/?ne=" + docLastModified());
    }

    function loadNewerVersion() {
        $.ajax({
            type: "HEAD",
            url: "/",
            cache: false,
            success: function(data, textStatus, xhr) {
                console.log("SUCCESS", textStatus, 
                            "lastModifiedFromXHR(xhr)",
                            lastModifiedFromXHR(xhr),
                            "staleModifiedDate()",
                            staleModifiedDate());

                if(lastModifiedFromXHR(xhr) == staleModifiedDate()) {
                    console.log("Still stale, going again");
                    setTimeout(loadNewerVersion, 1000);
                } else {
                    console.log("Not stale anymore. Reloading");
                    window.location.reload();
                }
            }
        });
    }

    /* Provide the Last-Modified header from the XHR request in the
     * locale-specific format suitable for comparing to the format
     * used in document.lastModified
     */
    function lastModifiedFromXHR(xhr) {
        var dt = xhr.getResponseHeader("Last-Modified");
        console.log("xhr.getResponseHeader('Last-Modified')", dt);
        return (new Date(dt)).toString();
    }

    function staleModifiedDate() {
        if(parameterByName("ne").length === 0) {
            return null;
        } else {
            return (new Date(parameterByName("ne"))).toString();
        }
    }

    function docLastModified() {
        /* document.lastModified is browser dependant. In Chrome it does not give any
         * time zone information in the string. It is assumed that all lastModfied
         * is in GMT
         */
        var d = new Date(document.lastModified + " GMT");
        return d.toString();
    }

    /* Return value from querystring */
    function parameterByName(name)
    {
      name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
      var regexS = "[\\?&]" + name + "=([^&#]*)";
      var regex = new RegExp(regexS);
      var results = regex.exec(window.location.search);
      if(results == null)
        return "";
      else
        return decodeURIComponent(results[1].replace(/\+/g, " "));
    }

  </script>
  </body>
</html>
