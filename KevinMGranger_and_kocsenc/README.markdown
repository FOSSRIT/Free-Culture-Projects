# Kevin M Granger's Project Proposal(s)

Note: Because I am unsure of the viablility of the first idea, I may pursue the alternate one mentioned here.o

Note: I am partnering with @kocsenc for this

## Digital Refugees

1. Run a tor exit node.

2. Inspect whatever traffic is actually inspectable (HTTP and DNS, most likely).

3. Using this data, stream it to a webpage in real-time, generating narratives from the information gleaned.

4. Take this traffic and put it back into a tor entrance node, so I'm not liable for tor traffic.

This will create a statement on refugees, topical to the current Syrian refugee crisis.

Optionally, the site will accept donations to be given to both online privacy groups and organizations helping refugees.

The donations would help match the current state of many refugees-- many "helping" them will take their money, but not
actually get them to where they want to go.

Perhaps I can even throttle the forwarding unless donations are made.


### Risks

I will need to see how much traffic is truly inspectable. If most of the traffic is encrypted, there's not much I can do.

Also, I'll need to see what the latency is like after sending requests back through-- if I'm regarded as an unhealthy exit node,
that will cause issues as well.



## Social Security

A work of interactive fiction, which you interact with in unconventional ways.

You run a fake social network in a VM, and you must break in to it via standard InfoSec cracking practices.

Depending upon how you interact with it, the story will advance differently.


### Risks


This is a seriously large scope, and may be limited to a single encounter due to time constraints.

It also makes the game inaccessible to certain crowds-- an alternative idea is to offer different interfaces to the game,
and offer a different lens of experience through each. However, this becomes a scope issue yet again,
and may be drifting away from the core idea.
