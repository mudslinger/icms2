#coding:utf-8
class FormPermission < ActiveRecord::Base
  belongs_to :form
  belongs_to :user
end