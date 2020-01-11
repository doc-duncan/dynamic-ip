## Overview

This service monitors the current public IP of the machine it is running on. It keeps an updated IP record
in a given S3 bucket. This comes in handy if you need dynamic DNS. I initially created it because I wanted
to SSH into my home laptop behind my router using port forwarding. Because my home router IP can change and
my laptop only has a private IP, I run this service on my machine to update me with the current router IP.
This way I am always able to connect even if my ISP allocates a new IP for my router.


## Notes

- credentials must be mounted in container with access to bucket
- env vars must be set to include S3_BUCKET_NAME and S3_FILE_NAME