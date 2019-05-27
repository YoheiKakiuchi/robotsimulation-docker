### after ros_gl
FROM yoheikakiuchi/rtmros_choreonoid:latest

###
ADD ./my_entrypoint.sh /
ADD ./my_entryrc /
ENTRYPOINT ["/my_entrypoint.sh"]
CMD ["bash"]
