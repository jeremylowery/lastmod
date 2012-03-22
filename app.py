import os
import time

from datetime import datetime
from wsgiref.simple_server import make_server

from mako.template import Template
from webob import Request, Response
from paste.httpserver import serve
from pytz import timezone

here = os.path.dirname(__file__)
data_fpath = os.path.join(here, 'data.txt')

def app(environ, start_response):
    req = Request(environ)
    res = Response(charset='utf-8', last_modified=last_modified())

    if req.if_modified_since and req.if_modified_since >= last_modified():
        res.status = 304
        return res(environ, start_response)

    if req.method == 'HEAD':
        return res(environ, start_response)
    tmpl = template()
    res.write(tmpl.render(data=data(), req=req))
    return res(environ, start_response)

def data():
    f = open(data_fpath)
    dat = f.read(-1)
    f.close()
    return dat

def last_modified():
    source_tz = timezone('US/Central')
    target_tz = timezone('UTC')
    # We have to cut it down to seconds by casting to int 
    # because the browser's returned header is down to seconds and
    # the platform's time resolution is to the microsecond.
    mtime = int(os.path.getmtime(data_fpath))
    dt = datetime.fromtimestamp(mtime, source_tz)
    return dt.astimezone(target_tz)

def template():
    path = os.path.join(here, 'app.mako')
    tmpl = Template(filename=path)
    return tmpl

if __name__ == '__main__':
    serve(app,
        host='0.0.0.0',
        port=8000,
        daemon_threads=True,
        protocol_version='HTTP/1.1')
