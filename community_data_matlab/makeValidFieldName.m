function [ validFieldname ] = makeValidFieldName( fieldname )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

fieldname(ismember(fieldname,'()[]@,:;!)')) = [];
fieldname(ismember(fieldname,' .-/')) = ['_'];

validFieldname = fieldname;
end

