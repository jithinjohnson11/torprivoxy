FROM debian:wheezy

MAINTAINER Arulraj Venni <me@arulraj.net>

# Install privoxy and tor
RUN apt-get update -qq \
	&& apt-get install -y privoxy tor supervisor \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/* /tmp/* /var/tmp/* \
	&& mkdir -p /opt/supervisor/conf.d /opt/privoxy /opt/tor

# Add custom supervisor config
COPY ./supervisord/supervisord.conf /opt/supervisor/supervisord.conf
COPY ./supervisord/privoxy-supervisor.conf /opt/supervisor/conf.d/privoxy-supervisor.conf
COPY ./supervisord/tor-supervisor.conf /opt/supervisor/conf.d/tor-supervisor.conf

# Add custom privoxy and tor config
COPY ./privoxy/config /opt/privoxy/config
COPY ./tor/torrc /opt/tor/torrc
COPY ./tor/torrsocks.conf /opt/tor/torrsocks.conf

# Ports
EXPOSE 8118 9050 9051

CMD ["supervisord", "-c", "/opt/supervisor/supervisord.conf"]