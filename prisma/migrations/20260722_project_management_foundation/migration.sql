BEGIN;

-- Repair the malformed one-value enum without losing existing project rows.
ALTER TABLE projects ALTER COLUMN status DROP DEFAULT;
ALTER TABLE projects
  ALTER COLUMN status TYPE VARCHAR(30)
  USING CASE
    WHEN status IS NULL THEN NULL
    WHEN status::text = 'Planning,Approved,In Progress,Completed,Cancelled' THEN 'PLANNING'
    ELSE UPPER(REPLACE(status::text, ' ', '_'))
  END;
ALTER TABLE projects ALTER COLUMN status SET DEFAULT 'PLANNING';
UPDATE projects SET status = 'PLANNING' WHERE status IS NULL;
ALTER TABLE projects ALTER COLUMN status SET NOT NULL;
ALTER TABLE projects DROP CONSTRAINT IF EXISTS projects_status_check;
ALTER TABLE projects ADD CONSTRAINT projects_status_check
  CHECK (status IN ('PLANNING', 'PENDING_APPROVAL', 'APPROVED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'REJECTED'));
DROP TYPE IF EXISTS enum_status;

ALTER TABLE projects
  ADD COLUMN IF NOT EXISTS rationale TEXT,
  ADD COLUMN IF NOT EXISTS expected_outcomes TEXT,
  ADD COLUMN IF NOT EXISTS target_participants INTEGER,
  ADD COLUMN IF NOT EXISTS created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS submitted_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS approved_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS submitted_at TIMESTAMP(6),
  ADD COLUMN IF NOT EXISTS approved_at TIMESTAMP(6),
  ADD COLUMN IF NOT EXISTS rejection_reason TEXT,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP;

CREATE TABLE IF NOT EXISTS project_objectives (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  objective_text TEXT NOT NULL,
  order_number INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS project_indicators (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  indicator_name VARCHAR(255) NOT NULL,
  target_value VARCHAR(100),
  actual_value VARCHAR(100),
  unit VARCHAR(50),
  result_note TEXT,
  order_number INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS project_activities (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  activity_name VARCHAR(255) NOT NULL,
  description TEXT,
  responsible_teacher_id INTEGER REFERENCES teachers(id) ON DELETE SET NULL,
  start_date DATE,
  end_date DATE,
  planned_budget DECIMAL(12,2) NOT NULL DEFAULT 0,
  status VARCHAR(30) NOT NULL DEFAULT 'PLANNING',
  order_number INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT project_activities_status_check
    CHECK (status IN ('PLANNING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'))
);

CREATE TABLE IF NOT EXISTS project_budgets (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  semester_id INTEGER NOT NULL REFERENCES semesters(id) ON DELETE RESTRICT,
  expense_category_id INTEGER REFERENCES expense_categories(id) ON DELETE SET NULL,
  planned_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  note TEXT,
  created_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT project_budgets_unique_plan UNIQUE (project_id, semester_id, expense_category_id),
  CONSTRAINT project_budgets_amount_check CHECK (planned_amount >= 0)
);

CREATE TABLE IF NOT EXISTS project_approvals (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  action VARCHAR(30) NOT NULL,
  action_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
  note TEXT,
  created_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT project_approvals_action_check
    CHECK (action IN ('SUBMITTED', 'APPROVED', 'REJECTED', 'RETURNED', 'CANCELLED'))
);

CREATE TABLE IF NOT EXISTS project_documents (
  id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  document_type VARCHAR(50) NOT NULL DEFAULT 'OTHER',
  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  mime_type VARCHAR(100),
  file_size INTEGER,
  uploaded_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE project_expenses
  ADD COLUMN IF NOT EXISTS note TEXT,
  ADD COLUMN IF NOT EXISTS vendor_name VARCHAR(255),
  ADD COLUMN IF NOT EXISTS disbursement_number VARCHAR(100),
  ADD COLUMN IF NOT EXISTS status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  ADD COLUMN IF NOT EXISTS approved_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS approved_at TIMESTAMP(6),
  ADD COLUMN IF NOT EXISTS rejection_reason TEXT;
ALTER TABLE project_expenses DROP CONSTRAINT IF EXISTS project_expenses_status_check;
ALTER TABLE project_expenses ADD CONSTRAINT project_expenses_status_check
  CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'PAID', 'CANCELLED'));
ALTER TABLE project_expenses DROP CONSTRAINT IF EXISTS project_expenses_amount_check;
ALTER TABLE project_expenses ADD CONSTRAINT project_expenses_amount_check CHECK (amount > 0);

CREATE INDEX IF NOT EXISTS idx_project_budgets_project ON project_budgets(project_id);
CREATE INDEX IF NOT EXISTS idx_project_expenses_project_semester ON project_expenses(project_id, semester_id);
CREATE INDEX IF NOT EXISTS idx_project_activities_project ON project_activities(project_id);
CREATE INDEX IF NOT EXISTS idx_project_indicators_project ON project_indicators(project_id);
CREATE INDEX IF NOT EXISTS idx_project_documents_project ON project_documents(project_id);

-- Consolidate duplicate funding-source labels already present in this database.
UPDATE projects SET budget_type_id = 1 WHERE budget_type_id = 4;
UPDATE projects SET budget_type_id = 2 WHERE budget_type_id = 6;
DELETE FROM budget_types WHERE id IN (4, 6);
CREATE UNIQUE INDEX IF NOT EXISTS budget_types_name_unique ON budget_types(name);
CREATE UNIQUE INDEX IF NOT EXISTS project_types_name_unique ON project_types(name);
CREATE UNIQUE INDEX IF NOT EXISTS expense_categories_name_unique ON expense_categories(name);

INSERT INTO expense_categories(name)
SELECT value FROM (VALUES
  ('ค่าครุภัณฑ์'), ('ค่าซ่อมแซม'), ('ค่าจ้างเหมาบริการ'), ('ค่าสาธารณูปโภค'),
  ('ค่าเช่าสถานที่'), ('ค่าที่พัก'), ('ค่าประชาสัมพันธ์'), ('ค่าเอกสาร'), ('ค่าใช้จ่ายอื่น')
) AS additions(value)
WHERE NOT EXISTS (SELECT 1 FROM expense_categories ec WHERE ec.name = additions.value);

-- Provide usable semester ranges from each academic year's dates.
UPDATE semesters s
SET start_date = CASE WHEN s.semester_number = 1 THEN ay.start_date ELSE make_date(EXTRACT(YEAR FROM ay.start_date)::int, 11, 1) END,
    end_date = CASE WHEN s.semester_number = 1 THEN make_date(EXTRACT(YEAR FROM ay.start_date)::int, 10, 31) ELSE ay.end_date END
FROM academic_years ay
WHERE ay.id = s.academic_year_id
  AND ay.start_date IS NOT NULL
  AND ay.end_date IS NOT NULL
  AND (s.start_date IS NULL OR s.end_date IS NULL);

UPDATE semesters
SET is_active = (CURRENT_DATE BETWEEN start_date AND end_date)
WHERE start_date IS NOT NULL AND end_date IS NOT NULL;

COMMIT;
