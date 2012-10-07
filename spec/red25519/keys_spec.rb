require 'spec_helper'

describe Ed25519::SigningKey do
  let(:key) { Ed25519::SigningKey.generate }
  let(:message) { "example message" }

  it "generates keypairs" do
    key.should be_a Ed25519::SigningKey
    key.verify_key.should be_a Ed25519::VerifyKey
  end

  it "signs messages" do
    key.sign(message).should be_a String
  end

  it "serializes to bytes" do
    bytes = key.to_bytes
    bytes.should be_a String
    bytes.length.should eq 32
  end

  it "serializes to hex" do
    hex = key.to_hex
    hex.should be_a String
    hex.length.should eq 64
  end

  it "initializes from hex" do
    hex = key.to_hex
    new_key = Ed25519::SigningKey.new(hex)
    key.to_bytes.should == new_key.to_bytes
  end
end

describe Ed25519::VerifyKey do
  let(:signing_key) { Ed25519::SigningKey.generate }
  let(:verify_key)  { signing_key.verify_key }
  let(:message)     { "example message" }

  it "verifies messages" do
    signature = signing_key.sign(message)
    verify_key.verify(signature, message).should be_true

    bad_signature = signature[0...63] + "X"
    verify_key.verify(bad_signature, message).should be_false
  end

  it "serializes to bytes" do
    bytes = verify_key.to_bytes
    bytes.should be_a String
    bytes.length.should eq 32
  end

  it "serializes to hex" do
    hex = verify_key.to_hex
    hex.should be_a String
    hex.length.should eq 64
  end

  it "initializes from hex" do
    hex = verify_key.to_hex
    new_key = Ed25519::VerifyKey.new(hex)
    verify_key.to_bytes.should == new_key.to_bytes
  end
end
