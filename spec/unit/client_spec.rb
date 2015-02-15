module Tika
  RSpec.describe Client do

    describe "#get_text" do
      let(:file) { File.new(File.join(FIXTURE_DIR, "Lorem_ipsum.docx")) }
      it "should return the text of the file" do
        text = subject.get_text(file: file, content_type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document")
        expect(text).to match(/^Lorem ipsum/)
      end
    end

    describe "#get_metadata" do
      let(:file) { File.new(File.join(FIXTURE_DIR, "Lorem_ipsum.pdf")) }
      it "should return the metadata of the file" do
        metadata = subject.get_metadata(file: file, content_type: "application/pdf")
        expect(metadata["Creation-Date"]).to eq("2015-02-15T01:54:41Z")
      end
    end

    describe "#get_version" do
      it "should return the Apache Tika server version" do
        expect(subject.get_version).to match(/^Apache Tika/)
      end
    end

  end
end
