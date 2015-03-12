require "spec_helper"

describe StyleCheck do
  describe "#run" do
    context "for a Ruby file" do
      it "runs LanguageWorker::Ruby" do
        file = double("File", filename: "foo.rb")
        pull_request = stub_pull_request(pull_request_files: [file])
        build_worker = double("BuildWorker")
        repo_config = stub_repo_config
        allow(RepoConfig).to receive(:new).and_return(repo_config)
        worker = stub_worker("LanguageWorker::Ruby")
        allow(LanguageWorker::Ruby).to receive(:new).and_return(worker)
        style_check = StyleCheck.new(pull_request, build_worker)

        style_check.run

        expect(LanguageWorker::Ruby).to have_received(:new).
          with(build_worker, file, repo_config, pull_request)
        expect(worker).to have_received(:run)
      end

      context "when ruby is not enabled for the repo" do
        it "does not run the worker"
      end

      context "when file is not included" do
        it "does not run the worker"
      end
    end

    context "for a CoffeeScript file" do
      it "runs LanguageWorker::CoffeeScript" do
        file = double("File", filename: "foo.coffee.js")
        pull_request = stub_pull_request(pull_request_files: [file])
        build_worker = double("BuildWorker")
        repo_config = stub_repo_config
        allow(RepoConfig).to receive(:new).and_return(repo_config)
        worker = stub_worker("LanguageWorker::CoffeeScript")
        allow(LanguageWorker::CoffeeScript).to receive(:new).and_return(worker)
        style_check = StyleCheck.new(pull_request, build_worker)

        style_check.run

        expect(LanguageWorker::CoffeeScript).to have_received(:new).
          with(build_worker, file, repo_config, pull_request)
        expect(worker).to have_received(:run)
      end

      context "when ruby is not enabled for the repo" do
        it "does not run the worker"
      end

      context "when file is not included" do
        it "does not run the worker"
      end
    end

    context "for a JavaScript file" do
      it "runs LanguageWorker::CoffeeScript" do
        file = double("File", filename: "foo.js")
        pull_request = stub_pull_request(pull_request_files: [file])
        build_worker = double("BuildWorker")
        repo_config = stub_repo_config
        allow(RepoConfig).to receive(:new).and_return(repo_config)
        worker = stub_worker("LanguageWorker::JavaScript")
        allow(LanguageWorker::JavaScript).to receive(:new).and_return(worker)
        style_check = StyleCheck.new(pull_request, build_worker)

        style_check.run

        expect(LanguageWorker::JavaScript).to have_received(:new).
          with(build_worker, file, repo_config, pull_request)
        expect(worker).to have_received(:run)
      end

      context "when ruby is not enabled for the repo" do
        it "does not run the worker"
      end

      context "when file is not included" do
        it "does not run the worker"
      end
    end

    context "for a SCSS file" do
      it "runs LanguageWorker::Scss" do
        file = double("File", filename: "foo.scss")
        pull_request = stub_pull_request(pull_request_files: [file])
        build_worker = double("BuildWorker")
        repo_config = stub_repo_config
        allow(RepoConfig).to receive(:new).and_return(repo_config)
        worker = stub_worker("LanguageWorker::Scss")
        allow(LanguageWorker::Scss).to receive(:new).and_return(worker)
        style_check = StyleCheck.new(pull_request, build_worker)

        style_check.run

        expect(LanguageWorker::Scss).to have_received(:new).
          with(build_worker, file, repo_config, pull_request)
        expect(worker).to have_received(:run)
      end

      context "when ruby is not enabled for the repo" do
        it "does not run the worker"
      end

      context "when file is not included" do
        it "does not run the worker"
      end
    end

    context "for an unsupported language" do
      it "runs the UnsupportedWorker and does nothing" do
        file = double("File", filename: "foo.unsupported")
        pull_request = stub_pull_request(pull_request_files: [file])
        build_worker = double("BuildWorker")
        repo_config = stub_repo_config
        allow(RepoConfig).to receive(:new).and_return(repo_config)
        worker = stub_worker("LanguageWorker::Unsupported")
        allow(LanguageWorker::Unsupported).to receive(:new).and_return(worker)
        style_check = StyleCheck.new(pull_request, build_worker)

        style_check.run

        expect(LanguageWorker::Unsupported).to have_received(:new).
          with(build_worker, file, repo_config, pull_request)
        expect(worker).to have_received(:run)
      end
    end
  end

  private

  def stub_pull_request(options = {})
    head_commit = double("Commit", file_content: "")
    defaults = {
      file_content: "",
      head_commit: head_commit,
      pull_request_files: [],
      repository_owner_name: "some_org"
    }

    double("PullRequest", defaults.merge(options))
  end

  def stub_repo_config(options = {})
    default_options = {
      enabled_for?: true,
      for: {},
      ignored_javascript_files: []
    }
    double(
      "RepoConfig",
      default_options.merge(options)
    )
  end

  def stub_worker(name, repo_config: stub_repo_config)
    double(
      name,
      enabled?: true,
      file_included?: true,
      run: true,
      repo_config: repo_config
    )
  end
end
