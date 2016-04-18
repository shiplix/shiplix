--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: analyzer_name; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE analyzer_name AS ENUM (
    'flog',
    'flay',
    'reek',
    'brakeman'
);


--
-- Name: build_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE build_state AS ENUM (
    'pending',
    'finished',
    'failed'
);


--
-- Name: build_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE build_type AS ENUM (
    'Builds::Push',
    'Builds::PullRequest'
);


--
-- Name: grade_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE grade_type AS ENUM (
    'A',
    'B',
    'C',
    'D',
    'F'
);


--
-- Name: owner_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE owner_type AS ENUM (
    'Owners::User',
    'Owners::Org'
);


--
-- Name: smell_subject_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE smell_subject_type AS ENUM (
    'Klass',
    'SourceFile'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: branches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE branches (
    id integer NOT NULL,
    repo_id integer NOT NULL,
    name character varying NOT NULL,
    "default" boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: branches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE branches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: branches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE branches_id_seq OWNED BY branches.id;


--
-- Name: builds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE builds (
    id integer NOT NULL,
    branch_id integer NOT NULL,
    type build_type NOT NULL,
    revision character varying(40) NOT NULL,
    pull_request_number integer,
    state build_state NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    smells_count integer DEFAULT 0,
    head_timestamp timestamp without time zone NOT NULL,
    prev_revision character varying,
    payload_data json NOT NULL,
    gpa numeric(2,1),
    files_count integer DEFAULT 0 NOT NULL
);


--
-- Name: builds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE builds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: builds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE builds_id_seq OWNED BY builds.id;


--
-- Name: changesets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE changesets (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    build_id integer NOT NULL,
    path character varying(1024) NOT NULL,
    grade_after grade_type NOT NULL,
    grade_before grade_type
);


--
-- Name: changesets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE changesets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: changesets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE changesets_id_seq OWNED BY changesets.id;


--
-- Name: files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE files (
    id integer NOT NULL,
    metrics jsonb DEFAULT '{}'::jsonb NOT NULL,
    smells_count integer DEFAULT 0 NOT NULL,
    branch_id integer NOT NULL,
    path character varying(1024) NOT NULL,
    grade grade_type DEFAULT 'A'::grade_type NOT NULL,
    pain integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE files_id_seq OWNED BY files.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE memberships (
    id integer NOT NULL,
    user_id integer NOT NULL,
    repo_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    admin boolean DEFAULT false NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE memberships_id_seq OWNED BY memberships.id;


--
-- Name: owners; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE owners (
    id integer NOT NULL,
    type owner_type NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    active_private_repos_count integer DEFAULT 0,
    stripe_customer_id character varying
);


--
-- Name: owners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE owners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: owners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE owners_id_seq OWNED BY owners.id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE plans (
    id integer NOT NULL,
    name character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    months integer DEFAULT 1 NOT NULL,
    price numeric(8,2) NOT NULL,
    repo_limit integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE plans_id_seq OWNED BY plans.id;


--
-- Name: repos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE repos (
    id integer NOT NULL,
    github_id integer NOT NULL,
    active boolean DEFAULT false NOT NULL,
    hook_id integer,
    name character varying NOT NULL,
    private boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    owner_id integer NOT NULL,
    activated_by integer
);


--
-- Name: repos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE repos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: repos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE repos_id_seq OWNED BY repos.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: smells; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE smells (
    id integer NOT NULL,
    message character varying(1024),
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    "position" int4range NOT NULL,
    file_id integer NOT NULL,
    analyzer analyzer_name NOT NULL,
    check_name character varying NOT NULL,
    pain integer DEFAULT 0 NOT NULL,
    fingerprint character varying(32) NOT NULL
);


--
-- Name: smells_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE smells_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smells_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE smells_id_seq OWNED BY smells.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subscriptions (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    plan_id integer NOT NULL,
    uuid character varying(36) NOT NULL,
    price numeric(8,2) NOT NULL,
    active_till timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    stripe_subscription_id character varying NOT NULL
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    github_username character varying NOT NULL,
    remember_token character varying NOT NULL,
    refreshing_repos boolean DEFAULT false,
    email_address character varying,
    access_token character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY branches ALTER COLUMN id SET DEFAULT nextval('branches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY builds ALTER COLUMN id SET DEFAULT nextval('builds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY changesets ALTER COLUMN id SET DEFAULT nextval('changesets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY files ALTER COLUMN id SET DEFAULT nextval('files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships ALTER COLUMN id SET DEFAULT nextval('memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY owners ALTER COLUMN id SET DEFAULT nextval('owners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY plans ALTER COLUMN id SET DEFAULT nextval('plans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY repos ALTER COLUMN id SET DEFAULT nextval('repos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY smells ALTER COLUMN id SET DEFAULT nextval('smells_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: branches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (id);


--
-- Name: builds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY builds
    ADD CONSTRAINT builds_pkey PRIMARY KEY (id);


--
-- Name: changesets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY changesets
    ADD CONSTRAINT changesets_pkey PRIMARY KEY (id);


--
-- Name: files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: owners_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (id);


--
-- Name: plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: repos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY repos
    ADD CONSTRAINT repos_pkey PRIMARY KEY (id);


--
-- Name: smells_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY smells
    ADD CONSTRAINT smells_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_branches_on_repo_id_and_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_branches_on_repo_id_and_name ON branches USING btree (repo_id, name);


--
-- Name: index_builds_on_branch_id_and_pull_request_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_builds_on_branch_id_and_pull_request_number ON builds USING btree (branch_id, pull_request_number);


--
-- Name: index_builds_on_head_timestamp; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_builds_on_head_timestamp ON builds USING btree (head_timestamp);


--
-- Name: index_changesets_on_build_id_and_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_changesets_on_build_id_and_created_at ON changesets USING btree (build_id, created_at);


--
-- Name: index_changesets_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_changesets_on_created_at ON changesets USING btree (created_at);


--
-- Name: index_files_on_branch_id_and_pain; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_files_on_branch_id_and_pain ON files USING btree (branch_id, pain);


--
-- Name: index_files_on_branch_id_and_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_files_on_branch_id_and_path ON files USING btree (branch_id, path);


--
-- Name: index_files_on_branch_id_and_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_files_on_branch_id_and_updated_at ON files USING btree (branch_id, updated_at);


--
-- Name: index_memberships_on_repo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_memberships_on_repo_id ON memberships USING btree (repo_id);


--
-- Name: index_memberships_on_user_id_and_repo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_memberships_on_user_id_and_repo_id ON memberships USING btree (user_id, repo_id);


--
-- Name: index_owners_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_owners_on_name ON owners USING btree (name);


--
-- Name: index_plans_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_plans_on_name ON plans USING btree (name);


--
-- Name: index_repos_on_activated_by; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_repos_on_activated_by ON repos USING btree (activated_by);


--
-- Name: index_repos_on_active; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_repos_on_active ON repos USING btree (active);


--
-- Name: index_repos_on_github_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_repos_on_github_id ON repos USING btree (github_id);


--
-- Name: index_repos_on_owner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_repos_on_owner_id ON repos USING btree (owner_id);


--
-- Name: index_smells_on_file_id_and_fingerprint; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_smells_on_file_id_and_fingerprint ON smells USING btree (file_id, fingerprint);


--
-- Name: index_subscriptions_on_plan_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_subscriptions_on_plan_id ON subscriptions USING btree (plan_id);


--
-- Name: index_subscriptions_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_subscriptions_on_uuid ON subscriptions USING btree (uuid);


--
-- Name: index_users_on_remember_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_remember_token ON users USING btree (remember_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_1c7f8bb258; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY smells
    ADD CONSTRAINT fk_rails_1c7f8bb258 FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE;


--
-- Name: fk_rails_2734d928b1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY repos
    ADD CONSTRAINT fk_rails_2734d928b1 FOREIGN KEY (activated_by) REFERENCES users(id) ON DELETE SET NULL;


--
-- Name: fk_rails_37ced7af95; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_rails_37ced7af95 FOREIGN KEY (owner_id) REFERENCES owners(id) ON DELETE CASCADE;


--
-- Name: fk_rails_483815476f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY repos
    ADD CONSTRAINT fk_rails_483815476f FOREIGN KEY (owner_id) REFERENCES owners(id) ON DELETE CASCADE;


--
-- Name: fk_rails_6a6462f765; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT fk_rails_6a6462f765 FOREIGN KEY (repo_id) REFERENCES repos(id);


--
-- Name: fk_rails_79160dec1d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY builds
    ADD CONSTRAINT fk_rails_79160dec1d FOREIGN KEY (branch_id) REFERENCES branches(id);


--
-- Name: fk_rails_8f2af769a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY branches
    ADD CONSTRAINT fk_rails_8f2af769a6 FOREIGN KEY (repo_id) REFERENCES repos(id);


--
-- Name: fk_rails_99326fb65d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT fk_rails_99326fb65d FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_a77b6bf0ff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY changesets
    ADD CONSTRAINT fk_rails_a77b6bf0ff FOREIGN KEY (build_id) REFERENCES builds(id) ON DELETE CASCADE;


--
-- Name: fk_rails_c09a2ce4f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY files
    ADD CONSTRAINT fk_rails_c09a2ce4f7 FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE CASCADE;


--
-- Name: fk_rails_ded37ae59a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_rails_ded37ae59a FOREIGN KEY (plan_id) REFERENCES plans(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20141219051157');

INSERT INTO schema_migrations (version) VALUES ('20141219102228');

INSERT INTO schema_migrations (version) VALUES ('20141219105312');

INSERT INTO schema_migrations (version) VALUES ('20141228175434');

INSERT INTO schema_migrations (version) VALUES ('20141229114602');

INSERT INTO schema_migrations (version) VALUES ('20141229114603');

INSERT INTO schema_migrations (version) VALUES ('20150102180036');

INSERT INTO schema_migrations (version) VALUES ('20150102180046');

INSERT INTO schema_migrations (version) VALUES ('20150102181103');

INSERT INTO schema_migrations (version) VALUES ('20150102181104');

INSERT INTO schema_migrations (version) VALUES ('20150109192409');

INSERT INTO schema_migrations (version) VALUES ('20150109192631');

INSERT INTO schema_migrations (version) VALUES ('20150127194910');

INSERT INTO schema_migrations (version) VALUES ('20150130032032');

INSERT INTO schema_migrations (version) VALUES ('20150203095935');

INSERT INTO schema_migrations (version) VALUES ('20150203173145');

INSERT INTO schema_migrations (version) VALUES ('20150209113215');

INSERT INTO schema_migrations (version) VALUES ('20150211190216');

INSERT INTO schema_migrations (version) VALUES ('20150215134254');

INSERT INTO schema_migrations (version) VALUES ('20150305100200');

INSERT INTO schema_migrations (version) VALUES ('20150308062951');

INSERT INTO schema_migrations (version) VALUES ('20150311152127');

INSERT INTO schema_migrations (version) VALUES ('20150315110852');

INSERT INTO schema_migrations (version) VALUES ('20150322183223');

INSERT INTO schema_migrations (version) VALUES ('20150327174555');

INSERT INTO schema_migrations (version) VALUES ('20150429112040');

INSERT INTO schema_migrations (version) VALUES ('20150429115433');

INSERT INTO schema_migrations (version) VALUES ('20150429120346');

INSERT INTO schema_migrations (version) VALUES ('20150625180722');

INSERT INTO schema_migrations (version) VALUES ('20150930235100');

INSERT INTO schema_migrations (version) VALUES ('20150930235101');

INSERT INTO schema_migrations (version) VALUES ('20150930235102');

INSERT INTO schema_migrations (version) VALUES ('20151005183000');

INSERT INTO schema_migrations (version) VALUES ('20151113081216');

INSERT INTO schema_migrations (version) VALUES ('20151121204321');

INSERT INTO schema_migrations (version) VALUES ('20160124103110');

INSERT INTO schema_migrations (version) VALUES ('20160128185949');

INSERT INTO schema_migrations (version) VALUES ('20160128190813');

INSERT INTO schema_migrations (version) VALUES ('20160201175147');

INSERT INTO schema_migrations (version) VALUES ('20160229181130');

INSERT INTO schema_migrations (version) VALUES ('20160314175210');

INSERT INTO schema_migrations (version) VALUES ('20160403092807');

INSERT INTO schema_migrations (version) VALUES ('20160414065207');

INSERT INTO schema_migrations (version) VALUES ('20160418051548');

