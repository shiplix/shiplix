require "rails_helper"

describe Builds::SaveService do
  let(:push_build) { create :push }
  let(:branch) { push_build.branch }
  subject(:service) { Builds::SaveService.new(push_build) }

  it "creates file if not exists" do
    push_build.collections.find_file("lib/test.rb")
    service.call
    expect(branch.files.where(path: "lib/test.rb")).to be_exists
  end

  it "overwrite file if exists" do
    file = create(:file, branch: branch, grade: "B", path: "lib/test.rb")
    raw_file = push_build.collections.find_file("lib/test.rb")
    raw_file.grade = "C"

    service.call

    expected_file = branch.files.find_by(path: "lib/test.rb")
    expect(expected_file.id).to eq file.id
    expect(expected_file.grade).to eq "C"
  end

  describe "creating changsets" do
    context "when prev build exists" do
      let(:prev_build) { create :push, branch: branch }
      let(:changeset) { push_build.changesets.find_by(path: "lib/test.rb") }

      before do
        allow(push_build).to receive(:prev_build).and_return(prev_build)
      end

      context "when file is new" do
        it "creates changeset" do
          push_build.collections.find_file("lib/test.rb")
          service.call

          expect(changeset).to be_present
          expect(changeset.path).to eq "lib/test.rb"
          expect(changeset.grade_after).to eq "A"
          expect(changeset.grade_before).to be nil
        end
      end

      context "when file is not new" do
        context "when grade is changed" do
          it "creates changeset" do
            file = create :file, branch: branch, grade: "B", path: "lib/test.rb"
            raw_file = push_build.collections.find_file("lib/test.rb")
            raw_file.grade = "A"

            service.call

            expect(changeset).to be_present
            expect(changeset.path).to eq "lib/test.rb"
            expect(changeset.grade_after).to eq "A"
            expect(changeset.grade_before).to eq "B"
          end
        end

        context "when grade the same" do
          it "doesn't create changeset" do
            file = create :file, branch: branch, grade: "B", path: "lib/test.rb"
            raw_file = push_build.collections.find_file("lib/test.rb")
            raw_file.grade = "B"

            service.call

            expect(changeset).to be_blank
          end
        end
      end
    end
  end

  describe "saving smells" do
    context "when same smell exists" do
      it "doesn't create new smell" do
        file = create :file, branch: branch
        smell = create :smell, file: file, fingerprint: "qwerty"

        raw_file = push_build.collections.find_file(file.path)
        raw_smell = push_build.collections.make_smell(raw_file, analyzer: smell.analyzer, check_name: smell.check_name)
        allow(raw_smell).to receive(:fingerprint).and_return(smell.fingerprint)

        service.call

        file.reload
        expect(file.smells.count).to eq 1
        expect(file.smells.first).to eq smell
      end
    end

    context "when smell is new" do
      it "creates a smell" do
        raw_file = push_build.collections.find_file("lib/test.rb")
        raw_smell = push_build.collections.make_smell(raw_file, analyzer: "flog", check_name: "overall")

        service.call

        file = branch.files.find_by(path: "lib/test.rb")
        expect(file.smells.count).to eq 1
      end
    end
  end
end
