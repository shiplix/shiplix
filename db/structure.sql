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
-- Name: smell_subject_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE smell_subject_type AS ENUM (
    'Klass',
    'SourceFile'
);


--
-- Name: smell_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE smell_type AS ENUM (
    'Smells::Flog',
    'Smells::Flay',
    'Smells::Reek',
    'Smells::Rubocop',
    'Smells::Brakeman'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: branches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE branches (
    id integer NOT NULL,
    repo_id integer NOT NULL,
    name character varying(255) NOT NULL,
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
    updated_at timestamp without time zone
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
-- Name: klass_source_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE klass_source_files (
    id integer NOT NULL,
    klass_id integer NOT NULL,
    source_file_id integer NOT NULL,
    line integer NOT NULL,
    line_end integer NOT NULL
);


--
-- Name: klass_source_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE klass_source_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: klass_source_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE klass_source_files_id_seq OWNED BY klass_source_files.id;


--
-- Name: klasses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE klasses (
    id integer NOT NULL,
    build_id integer NOT NULL,
    name character varying(255) NOT NULL,
    rating integer,
    complexity integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: klasses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE klasses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: klasses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE klasses_id_seq OWNED BY klasses.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    smell_id integer NOT NULL,
    source_file_id integer NOT NULL,
    line integer NOT NULL,
    num_lines integer DEFAULT 0 NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE memberships (
    id integer NOT NULL,
    user_id integer NOT NULL,
    repo_id integer NOT NULL,
    owner boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
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
-- Name: repos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE repos (
    id integer NOT NULL,
    github_id integer NOT NULL,
    active boolean DEFAULT false NOT NULL,
    hook_id integer,
    full_github_name character varying(255) NOT NULL,
    private boolean DEFAULT false NOT NULL,
    in_organization boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deploy_key_id integer
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
    version character varying(255) NOT NULL
);


--
-- Name: smells; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE smells (
    id integer NOT NULL,
    build_id integer NOT NULL,
    subject_id integer NOT NULL,
    subject_type smell_subject_type NOT NULL,
    type smell_type NOT NULL,
    message character varying(255),
    score integer,
    method_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    trait character varying(255)
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
-- Name: source_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE source_files (
    id integer NOT NULL,
    build_id integer NOT NULL,
    path character varying(2048) NOT NULL,
    name character varying(255) NOT NULL,
    rating integer,
    complexity integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: source_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE source_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: source_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE source_files_id_seq OWNED BY source_files.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    github_username character varying(255) NOT NULL,
    remember_token character varying(255) NOT NULL,
    refreshing_repos boolean DEFAULT false,
    email_address character varying(255),
    access_token character varying(255) NOT NULL,
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

ALTER TABLE ONLY klass_source_files ALTER COLUMN id SET DEFAULT nextval('klass_source_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY klasses ALTER COLUMN id SET DEFAULT nextval('klasses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships ALTER COLUMN id SET DEFAULT nextval('memberships_id_seq'::regclass);


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

ALTER TABLE ONLY source_files ALTER COLUMN id SET DEFAULT nextval('source_files_id_seq'::regclass);


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
-- Name: klass_source_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY klass_source_files
    ADD CONSTRAINT klass_source_files_pkey PRIMARY KEY (id);


--
-- Name: klasses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY klasses
    ADD CONSTRAINT klasses_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


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
-- Name: source_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY source_files
    ADD CONSTRAINT source_files_pkey PRIMARY KEY (id);


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
-- Name: index_klass_files_on_source_file_id_and_line_and_line_end; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_klass_files_on_source_file_id_and_line_and_line_end ON klass_source_files USING btree (source_file_id, line, line_end);


--
-- Name: index_klass_source_files_on_klass_id_and_source_file_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_klass_source_files_on_klass_id_and_source_file_id ON klass_source_files USING btree (klass_id, source_file_id);


--
-- Name: index_klasses_on_build_id_and_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_klasses_on_build_id_and_name ON klasses USING btree (build_id, name);


--
-- Name: index_locations_on_smell_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locations_on_smell_id ON locations USING btree (smell_id);


--
-- Name: index_locations_on_source_file_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locations_on_source_file_id ON locations USING btree (source_file_id);


--
-- Name: index_memberships_on_repo_id_and_owner; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_memberships_on_repo_id_and_owner ON memberships USING btree (repo_id, owner) WHERE (owner = true);


--
-- Name: index_memberships_on_user_id_and_repo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_memberships_on_user_id_and_repo_id ON memberships USING btree (user_id, repo_id);


--
-- Name: index_repos_on_active; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_repos_on_active ON repos USING btree (active);


--
-- Name: index_repos_on_github_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_repos_on_github_id ON repos USING btree (github_id);


--
-- Name: index_smells_on_build_id_and_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_smells_on_build_id_and_type ON smells USING btree (build_id, type);


--
-- Name: index_smells_on_subject_id_and_subject_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_smells_on_subject_id_and_subject_type ON smells USING btree (subject_id, subject_type);


--
-- Name: index_source_files_on_build_id_and_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_source_files_on_build_id_and_path ON source_files USING btree (build_id, path);


--
-- Name: index_users_on_remember_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_remember_token ON users USING btree (remember_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: branches_repo_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY branches
    ADD CONSTRAINT branches_repo_id_fk FOREIGN KEY (repo_id) REFERENCES repos(id) ON DELETE CASCADE;


--
-- Name: builds_branch_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY builds
    ADD CONSTRAINT builds_branch_id_fk FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE CASCADE;


--
-- Name: klass_source_files_klass_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY klass_source_files
    ADD CONSTRAINT klass_source_files_klass_id_fk FOREIGN KEY (klass_id) REFERENCES klasses(id) ON DELETE CASCADE;


--
-- Name: klass_source_files_source_file_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY klass_source_files
    ADD CONSTRAINT klass_source_files_source_file_id_fk FOREIGN KEY (source_file_id) REFERENCES source_files(id) ON DELETE CASCADE;


--
-- Name: klasses_build_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY klasses
    ADD CONSTRAINT klasses_build_id_fk FOREIGN KEY (build_id) REFERENCES builds(id) ON DELETE CASCADE;


--
-- Name: locations_smell_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_smell_id_fk FOREIGN KEY (smell_id) REFERENCES smells(id) ON DELETE CASCADE;


--
-- Name: locations_source_file_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_source_file_id_fk FOREIGN KEY (source_file_id) REFERENCES source_files(id) ON DELETE CASCADE;


--
-- Name: memberships_repo_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_repo_id_fk FOREIGN KEY (repo_id) REFERENCES repos(id) ON DELETE CASCADE;


--
-- Name: memberships_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: smells_build_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY smells
    ADD CONSTRAINT smells_build_id_fk FOREIGN KEY (build_id) REFERENCES builds(id) ON DELETE CASCADE;


--
-- Name: source_files_build_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY source_files
    ADD CONSTRAINT source_files_build_id_fk FOREIGN KEY (build_id) REFERENCES builds(id) ON DELETE CASCADE;


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

