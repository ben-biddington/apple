# Setting up your source calendar

Calendar must **not** be set to "Share only my free/busy information (Hide details)". (see _Calendar Details_ > _Sharing Settings_.) 

We need to full version in order to get the event times, and [getTimes](http://code.google.com/apis/gdata/jsdoc/2.2/google/gdata/EventEntry.html#getTimes) returns nothing from a _basic_ calendar. 

We **must* fetch the `public/full` version of the calendar, which is not available when the "Share only my free/busy information (Hide details)" box is checked. We need this version because it has extra nodes. 

## Full

    <entry>
      <id>http://www.google.com/calendar/feeds/vddp2rq2f0j1asv103n6jps2og%40group.calendar.google.com/public/full/suecdo65gq0jnoisoudem8oksg</id>
      <published>2012-01-21T23:47:13.000Z</published>
      <updated>2012-01-27T23:51:10.000Z</updated>
      <category scheme="http://schemas.google.com/g/2005#kind" term="http://schemas.google.com/g/2005#event"/>
      <title type="text">Example busy days for single month</title>
      <content type="text"/>
      <link rel="alternate" type="text/html" href="https://www.google.com/calendar/event?eid=c3VlY2RvNjVncTBqbm9pc291ZGVtOG9rc2cgdmRkcDJycTJmMGoxYXN2MTAzbjZqcHMyb2dAZw" title="alternate"/>
      <link rel="self" type="application/atom+xml" href="https://www.google.com/calendar/feeds/vddp2rq2f0j1asv103n6jps2og%40group.calendar.google.com/public/full/suecdo65gq0jnoisoudem8oksg"/>
      <author>
        <name>full</name>
      </author>
      <gd:comments>
        <gd:feedLink href="https://www.google.com/calendar/feeds/vddp2rq2f0j1asv103n6jps2og%40group.calendar.google.com/public/full/suecdo65gq0jnoisoudem8oksg/comments"/>
      </gd:comments>
      <gd:eventStatus value="http://schemas.google.com/g/2005#event.confirmed"/>
      <gd:where valueString=""/>
      <gd:who email="vddp2rq2f0j1asv103n6jps2og@group.calendar.google.com" rel="http://schemas.google.com/g/2005#event.organizer" valueString="[TEST] Split Apple Rock availability"/>
      <gd:when endTime="2012-01-01" startTime="2011-12-28"/>
      <gd:transparency value="http://schemas.google.com/g/2005#event.opaque"/>
      <gCal:anyoneCanAddSelf value="false"/>
      <gCal:guestsCanInviteOthers value="true"/>
      <gCal:guestsCanModify value="false"/>
      <gCal:guestsCanSeeGuests value="true"/>
      <gCal:sequence value="6"/>
      <gCal:uid value="suecdo65gq0jnoisoudem8oksg@google.com"/>
    </entry>

## Basic

    <entry>
      <id>http://www.google.com/calendar/feeds/vddp2rq2f0j1asv103n6jps2og%40group.calendar.google.com/public/basic/suecdo65gq0jnoisoudem8oksg</id>
      <published>2012-01-21T23:47:13.000Z</published>
      <updated>2012-01-27T23:12:03.000Z</updated>
      <category scheme="http://schemas.google.com/g/2005#kind" term="http://schemas.google.com/g/2005#event"/>
      <title type="html">busy</title>
      <summary type="html">When: Wed 28 Dec 2011 to Sat 31 Dec 2011&amp;nbsp;&lt;br&gt;</summary>
      <link rel="alternate" type="text/html" href="https://www.google.com/calendar/event?eid=c3VlY2RvNjVncTBqbm9pc291ZGVtOG9rc2cgdmRkcDJycTJmMGoxYXN2MTAzbjZqcHMyb2dAZw" title="alternate"/>
      <link rel="self" type="application/atom+xml" href="https://www.google.com/calendar/feeds/vddp2rq2f0j1asv103n6jps2og%40group.calendar.google.com/public/basic/suecdo65gq0jnoisoudem8oksg"/>
      <author>
        <name>[TEST] Split Apple Rock availability</name>
      </author>
    </entry>

(So the times are not returned unless you _do_ ask for `public/full`)

An event must be __public__, and you must set it to __busy__ for it to show.

# Tips

To find out what methods a javscript object has, for example all its getters: 
    var anyObject = "xxx";
   	
    for (var prop in anyObject) {
      if (prop.indexOf("get") != -1) console.log(prop);
    }

# Deployment
## Downloading

It is easiest to do this with ftp directly, the ruby interface does not support mget.

1. start ftp
1. `prompt` turns off interactive mode
1. make sure the local dirs are all present (don't know how the `! mkdir directory` option works)
1. run something like `$ mget public_html/**/*`
1. verify all files have been copied

## Uploading

1. send local_file remote_file

## TODO

Imagine automatic deploy changes only. Perhaps keep the current git version on the remote server. 
Then download it, compare with head and generate a changeset.
