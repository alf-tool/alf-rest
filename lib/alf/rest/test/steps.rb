def client
  @client
end

Before do
  @client ||= Alf::Rest::Test::Client.new(Alf::Rest::Test.config)
end

After do
  client.disconnect
end

Given /^the (.*?) relvar is empty$/ do |relvar|
  client.with_relvar(relvar) do |rv|
    rv.delete
  end
end

Given /^the (.*?) relvar has the following value:$/ do |relvar,table|
  client.with_relvar(relvar) do |rv|
    rv.affect Relation(rv.heading.coerce(table.hashes))
  end
end

Given /^the following (.*?) relation is mapped under (.*):$/ do |prototype, url, table|
  client.with_relvar(prototype) do |rv|
    rv.affect Relation(rv.heading.coerce(table.hashes))
  end
  app.get(url) do
    agent.relvar = prototype
    agent.mode   = :relation
    agent.get
  end
  app.get("#{url}/:id") do
    agent.relvar = prototype
    agent.mode   = :tuple
    agent.primary_key_equal(params[:id])
    agent.get
  end
  app.delete(url) do
    agent.relvar = prototype
    agent.mode   = :relation
    agent.delete
  end
  app.delete("#{url}/:id") do
    agent.relvar = prototype
    agent.mode   = :tuple
    agent.primary_key_equal(params[:id])
    agent.delete
  end
  app.post(url) do
    agent.locator = url
    agent.relvar  = prototype
    agent.mode    = :relation
    agent.body    = payload rescue halt(400)
    agent.post
  end
  app.patch("#{url}/:id") do
    agent.locator = url
    agent.relvar = prototype
    agent.mode   = :tuple
    agent.primary_key_equal(params[:id])
    agent.body   = payload rescue halt(400)
    agent.patch
  end
  app.put("#{url}/:id") do
    agent.locator = url
    agent.relvar = prototype
    agent.mode   = :tuple
    agent.primary_key_equal(params[:id])
    agent.body   = payload rescue halt(400)
    agent.patch
  end
end

Given /^the "(.*?)" header is "(.*?)"$/ do |k,v|
  client.header(k,v)
end

Given /^the "(.*?)" header is not set$/ do |k|
  client.header(k,nil)
end

Given /^the "(.*?)" parameter is "(.*?)"$/ do |k,v|
  client.parameter(k.to_sym,v)
end

Given /^the body of the next request is the following tuple:$/ do |table|
  client.body = table.hashes.first
end

Given /^the body of the next request is the following (.*?) tuple:$/ do |prototype,table|
  client.with_relvar(prototype) do |rv|
    client.body = rv.heading.coerce(table.hashes.first)
  end
end

Given /^the body of the next request is the following (.*?) tuples:$/ do |prototype,table|
  client.with_relvar(prototype) do |rv|
    client.body = rv.heading.coerce(table.hashes)
  end
end

Given /^the body has the following (.*?) attribute (.*?):$/ do |attrname,prototype,table|
  client.body ||= {}
  client.with_relvar(prototype) do |rv|
    client.body[attrname.to_sym] = rv.heading.coerce(table.hashes)
  end
end

Given /^the body has the following (.*?) rva (.*?):$/ do |attrname,prototype,table|
  client.body ||= {}
  client.with_relvar(prototype) do |rv|
    client.body[attrname.to_sym] = rv.heading.coerce(table.hashes)
  end
end

Given /^the body has the following (.*?) tva (.*?):$/ do |attrname,prototype,table|
  client.body ||= {}
  client.with_relvar(prototype) do |rv|
    client.body[attrname.to_sym] = Relation(rv.heading.coerce(table.hashes)).tuple_extract
  end
end

Given /^the body has a nil for (.*?)$/ do |attrname|
  client.body ||= {}
  client.body[attrname.to_sym] = nil
end

Given /^I make a (.*?) (on|to) (.*)$/ do |verb, _, url|
  client.send(verb.downcase.to_sym, url)
end

Then /^the status should be (\d+)$/ do |status|
  client.last_response.status.should eq(Integer(status))
end

Then /^the status should not be (\d+)$/ do |status|
  client.last_response.status.should_not eq(Integer(status))
end

Then /^the content type should be (.*)$/ do |ct|
  client.last_response.content_type.should =~ Regexp.new(Regexp.escape(ct))
end

Then /^the Location header should not be set$/ do
  client.last_response.location.should be_nil
end

Given /^I follow the specified Location$/ do
  client.get(client.last_response.location)
end

Then /^the body should be empty$/ do
  client.body.should be_nil
end

Then /^the body should be a JSON array$/ do
  client.payload.should be_a(Array)
end

Then /^the body should be an empty JSON array$/ do
  client.payload.should eq([])
end

Then /^the body should be a JSON object$/ do
  client.payload.should be_a(Hash)
end

Then /^the body contains "(.*?)"$/ do |expected|
  client.last_response.body.should match(Regexp.compile(Regexp.escape(expected)))
end

Then /^a decoded tuple should equal:$/ do |expected|
  expected = Tuple(expected.hashes.first)
  @decoded = Tuple(client.payload)
  @decoded.project(expected.keys).should eq(expected)
end

Then /^a decoded (.*?) tuple should equal:$/ do |prototype,expected|
  client.with_relvar(prototype) do |rv|
    expected = Relation(rv.heading.coerce(expected.hashes.first))
    @decoded = Relation(rv.heading.coerce(client.payload))
    @decoded.project(expected.attribute_list).should eq(expected)
  end
end

Then /^a decoded (.*?) relation should equal:$/ do |prototype,expected|
  client.with_relvar(prototype) do |rv|
    expected = Relation(rv.heading.coerce(expected.hashes))
    @decoded = Relation(rv.heading.coerce(client.payload))
    @decoded.project(expected.attribute_list).should eq(expected)
  end
end

Then /^a decoded relation should be (.*?)$/ do |expected|
  client.with_relvar(expected) do |rv|
    @decoded = Relation(rv.heading.coerce(client.payload))
    @decoded.should eq(rv.value)
  end  
end

Then /^a decoded (.*?) relation should be empty$/ do |prototype|
  client.with_relvar(prototype) do |rv|
    @decoded = Relation(rv.heading.coerce(client.payload))
    @decoded.should be_empty
  end
end

Then /^the size of a decoded relation should be (\d+)$/ do |size|
  @decoded = Relation(client.payload)
  @decoded.size.should eq(Integer(size))
end

Then /its (.*?) attribute should be nil/ do |attrname|
  @decoded.tuple_extract[attrname.to_sym].should be_nil
end

Then /^its (.*?) tva should equal:$/ do |tva,expected|
  decoded  = Relation(@decoded.tuple_extract[tva.to_sym])
  expected = Relation(decoded.heading.coerce(expected.hashes))
  decoded.project(expected.attribute_list).tuple_extract.should eq(expected.tuple_extract)
end

Then /^its (.*?) rva should equal:$/ do |rva,expected|
  decoded  = Relation(@decoded.tuple_extract[rva.to_sym])
  expected = Relation(decoded.heading.coerce(expected.hashes))
  decoded.project(expected.attribute_list).should eq(expected)
end

Then /^its (.*?) rva should be empty$/ do |rva|
  tuple = @decoded.tuple_extract
  tuple[rva.to_sym].should be_empty
end

Then /^its (.*?) rva should have size (\d+)$/ do |rva,size|
  tuple = @decoded.tuple_extract
  tuple[rva.to_sym].size.should eq(Integer(size))
end
