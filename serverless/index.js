'use strict';

exports.http = (request, response) => {
  response.status(200).send(request.body);
};

exports.event = (event, callback) => {
  callback();
};
