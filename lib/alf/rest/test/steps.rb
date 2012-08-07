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
    agent.relvar = prototype
    agent.mode   = :relation
    agent.post
  end
  app.patch("#{url}/:id") do
    agent.relvar = prototype
    agent.mode   = :tuple
    agent.primary_key_equal(params[:id])
    agent.patch
  end
  app.put("#{url}/:id") do
    agent.relvar = prototype
    agent.mode   = :tuple
    agent.primary_key_equal(params[:id])
    agent.patch
  end
end

Given /^the JSON body of the next request is the following (.*?) tuple:$/ do |prototype,table|
  client.with_relvar(prototype) do |rv|
    client.json_body = rv.heading.coerce(table.hashes.first)
  end
end

Given /^the JSON body of the next request is the following (.*?) tuples:$/ do |prototype,table|
  client.with_relvar(prototype) do |rv|
    client.json_body = rv.heading.coerce(table.hashes)
  end
end

Given /^I make a (.*?) (on|to) (.*)$/ do |verb, _, url|
  client.send(verb.downcase.to_sym, url)
end

Then /^the status should be (\d+)$/ do |status|
  client.last_response.status.should eq(Integer(status))
end

Then /^the content type should be (.*)$/ do |ct|
  client.last_response.content_type.should =~ Regexp.new(Regexp.escape(ct))
end

Then /^the body should be a JSON array$/ do
  client.loaded_body.should be_a(Array)
end

Then /^the body should be an empty JSON array$/ do
  client.loaded_body.should eq([])
end

Then /^the body should be a JSON object$/ do
  client.loaded_body.should be_a(Hash)
end

Then /^a decoded (.*?) tuple should equal:$/ do |prototype,expected|
  client.with_relvar(prototype) do |rv|
    body = rv.heading.coerce(client.loaded_body)
    expected = rv.heading.coerce(expected.hashes.first)
    body.should eq(expected)
  end
end

Then /^a decoded (.*?) relation should equal:$/ do |prototype,expected|
  client.with_relvar(prototype) do |rv|
    body     = Relation(rv.heading.coerce(client.loaded_body))
    expected = Relation(rv.heading.coerce(expected.hashes))
    body.should eq(expected)
  end
end

Then /^a decoded relation should be (.*?)$/ do |expected|
  client.with_relvar(expected) do |rv|
    body = Relation(rv.heading.coerce(client.loaded_body))
    body.should eq(rv.value)
  end  
end

Then /^a decoded (.*?) relation should be empty$/ do |prototype|
  client.with_relvar(prototype) do |rv|
    body = Relation(rv.heading.coerce(client.loaded_body))
    body.should be_empty
  end
end
