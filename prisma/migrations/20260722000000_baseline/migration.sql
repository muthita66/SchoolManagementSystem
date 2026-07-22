-- CreateEnum
CREATE TYPE "enum_event_status" AS ENUM ('DRAFT,PUBLISHED,CANCELLED,COMPLETED');

-- CreateEnum
CREATE TYPE "enum_peyment_method" AS ENUM ('เงินสด', 'โอน', 'เช็ค');

-- CreateEnum
CREATE TYPE "enum_student_status" AS ENUM ('active', 'suspended', 'graduated', 'withdrawn', 'dismissed');

-- CreateTable
CREATE TABLE "academic_years" (
    "id" SERIAL NOT NULL,
    "year_name" VARCHAR(20) NOT NULL,
    "start_date" DATE,
    "end_date" DATE,
    "is_active" BOOLEAN DEFAULT false,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "academic_years_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assessment_items" (
    "id" SERIAL NOT NULL,
    "grade_category_id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "max_score" DECIMAL(5,2) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "assessment_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attendance_records" (
    "id" SERIAL NOT NULL,
    "student_id" INTEGER,
    "check_date" DATE NOT NULL,
    "check_time" TIME(6),
    "status_id" INTEGER,
    "remark" VARCHAR(255),

    CONSTRAINT "attendance_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attendance_status" (
    "id" INTEGER NOT NULL,
    "status_name" VARCHAR(50) NOT NULL,

    CONSTRAINT "attendance_status_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "action" VARCHAR(100) NOT NULL,
    "table_name" VARCHAR(100) NOT NULL,
    "record_id" INTEGER,
    "old_data" JSONB,
    "new_data" JSONB,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "behavior_records" (
    "id" SERIAL NOT NULL,
    "student_id" INTEGER,
    "behavior_type_id" INTEGER,
    "reporter_user_id" INTEGER,
    "incident_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "points_awarded" INTEGER NOT NULL,
    "note" TEXT,
    "status" VARCHAR(20) DEFAULT 'PENDING',
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "approved_by_user_id" INTEGER,
    "approved_at" TIMESTAMP(6),
    "reject_reason" TEXT,
    "semester_id" INTEGER,
    "recorded_by" INTEGER,

    CONSTRAINT "behavior_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "behavior_types" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "is_positive" BOOLEAN NOT NULL,
    "default_points" INTEGER NOT NULL,
    "description" TEXT,
    "is_active" BOOLEAN DEFAULT true,

    CONSTRAINT "behavior_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "budget_types" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "budget_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "buildings" (
    "id" SERIAL NOT NULL,
    "building_name" VARCHAR(100) NOT NULL,
    "total_floors" INTEGER,

    CONSTRAINT "buildings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "class_schedule" (
    "schedule_id" SERIAL NOT NULL,
    "classroom_id" INTEGER NOT NULL,
    "subject_id" INTEGER NOT NULL,
    "semester_id" INTEGER NOT NULL,
    "day_of_week_id" INTEGER NOT NULL,
    "period_id" INTEGER NOT NULL,
    "start_time" TIME(6) NOT NULL,
    "end_time" TIME(6) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "class_schedule_pkey" PRIMARY KEY ("schedule_id")
);

-- CreateTable
CREATE TABLE "classroom_assignments" (
    "id" SERIAL NOT NULL,
    "teacher_id" INTEGER NOT NULL,
    "capacity" INTEGER,
    "status" VARCHAR(20) DEFAULT 'open',
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "academic_year_id" INTEGER NOT NULL,
    "classroom_id" INTEGER NOT NULL,

    CONSTRAINT "teaching_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "classroom_students" (
    "id" SERIAL NOT NULL,
    "classroom_id" INTEGER NOT NULL,
    "student_id" INTEGER NOT NULL,
    "academic_year_id" INTEGER NOT NULL,
    "roll_number" INTEGER,

    CONSTRAINT "classroom_students_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "classroom_subjects" (
    "id" SERIAL NOT NULL,
    "subject_id" INTEGER NOT NULL,
    "classroom_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "classroom_subjects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "classrooms" (
    "id" SERIAL NOT NULL,
    "room_name" VARCHAR(50) NOT NULL,
    "capacity" INTEGER,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "grade_level_id" INTEGER NOT NULL,

    CONSTRAINT "classrooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "day_of_weeks" (
    "id" INTEGER NOT NULL,
    "day_name_th" VARCHAR(20) NOT NULL,
    "day_name_en" VARCHAR(20) NOT NULL,
    "short_name" VARCHAR(10) NOT NULL,
    "color_code" VARCHAR(7),

    CONSTRAINT "day_of_weeks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "departments" (
    "id" SERIAL NOT NULL,
    "department_name" VARCHAR(100) NOT NULL,

    CONSTRAINT "departments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employment_types" (
    "id" SERIAL NOT NULL,
    "type_name" VARCHAR(100) NOT NULL,

    CONSTRAINT "employment_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_answers" (
    "id" SERIAL NOT NULL,
    "response_id" INTEGER,
    "question_id" INTEGER,
    "score_value" DECIMAL(5,2),
    "text_value" TEXT,

    CONSTRAINT "evaluation_answers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_categories" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "evaluator_role_id" INTEGER,
    "target_type" VARCHAR(50),

    CONSTRAINT "evaluation_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_choices" (
    "id" SERIAL NOT NULL,
    "question_id" INTEGER NOT NULL,
    "choice_text" TEXT NOT NULL,
    "order_number" INTEGER DEFAULT 1,

    CONSTRAINT "evaluation_choices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_forms" (
    "id" SERIAL NOT NULL,
    "category_id" INTEGER,
    "form_name" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "is_active" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "evaluation_forms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_question_types" (
    "id" SERIAL NOT NULL,
    "code_name" VARCHAR(50) NOT NULL,
    "display_name" VARCHAR(100) NOT NULL,
    "requires_choices" BOOLEAN DEFAULT false,
    "description" TEXT,

    CONSTRAINT "evaluation_question_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_questions" (
    "id" SERIAL NOT NULL,
    "section_id" INTEGER,
    "question_text" TEXT NOT NULL,
    "scale_type_id" INTEGER,
    "is_required" BOOLEAN DEFAULT true,
    "order_number" INTEGER NOT NULL,
    "question_type_id" INTEGER,

    CONSTRAINT "evaluation_questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_responses" (
    "id" SERIAL NOT NULL,
    "form_id" INTEGER,
    "evaluator_user_id" INTEGER,
    "target_student_id" INTEGER,
    "target_teacher_id" INTEGER,
    "target_subject_id" INTEGER,
    "status" VARCHAR(20) DEFAULT 'COMPLETED',
    "submitted_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "semester_id" INTEGER,

    CONSTRAINT "evaluation_responses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_scale_items" (
    "id" SERIAL NOT NULL,
    "scale_type_id" INTEGER,
    "label" VARCHAR(100) NOT NULL,
    "score_value" DECIMAL(5,2),
    "order_number" INTEGER NOT NULL,

    CONSTRAINT "evaluation_scale_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_scale_types" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,

    CONSTRAINT "evaluation_scale_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_schedules" (
    "id" SERIAL NOT NULL,
    "form_id" INTEGER,
    "semester_id" INTEGER,
    "start_time" TIMESTAMP(6) NOT NULL,
    "end_time" TIMESTAMP(6) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "evaluation_schedules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_sections" (
    "id" SERIAL NOT NULL,
    "form_id" INTEGER,
    "section_name" VARCHAR(200) NOT NULL,
    "section_description" TEXT,
    "order_number" INTEGER NOT NULL,

    CONSTRAINT "evaluation_sections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evaluation_types" (
    "id" SERIAL NOT NULL,
    "evaluation_name" VARCHAR(100) NOT NULL,

    CONSTRAINT "evaluation_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_targets" (
    "id" SERIAL NOT NULL,
    "event_id" INTEGER NOT NULL,
    "target_type" VARCHAR(30) NOT NULL,
    "target_value" VARCHAR(255),

    CONSTRAINT "event_targets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_types" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "color_code" VARCHAR(7),
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "event_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "events" (
    "id" SERIAL NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "start_datetime" TIMESTAMP(6) NOT NULL,
    "end_datetime" TIMESTAMP(6) NOT NULL,
    "is_all_day" BOOLEAN DEFAULT false,
    "location" VARCHAR(200),
    "created_by" INTEGER,
    "visibility" VARCHAR(20) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "teacher_id" INTEGER,
    "event_type_id" INTEGER,
    "department_id" INTEGER,
    "semester_id" INTEGER,
    "status" "enum_event_status",

    CONSTRAINT "events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expense_categories" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "expense_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "final_grades" (
    "id" SERIAL NOT NULL,
    "total_score" DECIMAL(6,2) NOT NULL,
    "letter_grade" VARCHAR(10),
    "grade_point" DECIMAL(3,2),
    "is_locked" BOOLEAN DEFAULT false,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "grade_scale_id" INTEGER,
    "student_id" INTEGER,
    "subject_id" INTEGER,
    "semester_id" INTEGER,
    "calculated_by" INTEGER,
    "calculated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "final_grades_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fitness_test_criteria" (
    "id" SERIAL NOT NULL,
    "test_name" VARCHAR(255) NOT NULL,
    "unit" VARCHAR(50) NOT NULL,
    "passing_threshold" DECIMAL NOT NULL,
    "comparison_type" VARCHAR(10) DEFAULT '>=',
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "academic_year" INTEGER,
    "gender" VARCHAR(20),
    "grade_level" VARCHAR(100),

    CONSTRAINT "fitness_test_criteria_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "genders" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,

    CONSTRAINT "genders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "grade_categories" (
    "id" SERIAL NOT NULL,
    "classroom_assignment_id" INTEGER NOT NULL,
    "weight_percent" DECIMAL(5,2) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "category_type_id" INTEGER,
    "name" VARCHAR(100) NOT NULL DEFAULT 'Category',

    CONSTRAINT "grade_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "grade_category_types" (
    "id" SERIAL NOT NULL,
    "type_name" VARCHAR(100) NOT NULL,
    "description" TEXT,

    CONSTRAINT "grade_category_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "grade_level" (
    "id" SERIAL NOT NULL,
    "grade_level_name" VARCHAR(30),

    CONSTRAINT "grade_level_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "grade_scale_groups" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "is_default" BOOLEAN DEFAULT false,
    "description" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "evaluation_type_id" INTEGER,

    CONSTRAINT "grade_scale_groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "grade_scales" (
    "id" SERIAL NOT NULL,
    "min_score" DECIMAL(5,2) NOT NULL,
    "max_score" DECIMAL(5,2) NOT NULL,
    "letter_grade" VARCHAR(5) NOT NULL,
    "grade_point" DECIMAL(3,2) NOT NULL,
    "grade_scale_group_id" INTEGER,

    CONSTRAINT "grade_scales_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "health_checkup_records" (
    "id" SERIAL NOT NULL,
    "student_id" INTEGER NOT NULL,
    "semester_id" INTEGER,
    "checkup_date" DATE NOT NULL,
    "weight" DECIMAL(5,2),
    "height" DECIMAL(5,2),
    "bmi" DECIMAL(4,2),
    "vision_left" VARCHAR(20),
    "vision_right" VARCHAR(20),
    "dental_status" VARCHAR(100),
    "doctor_note" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "health_checkup_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "learning_subject_groups" (
    "id" SERIAL NOT NULL,
    "group_name" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "learning_subject_groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "name_prefixes" (
    "id" SERIAL NOT NULL,
    "prefix_name" VARCHAR(50) NOT NULL,

    CONSTRAINT "name_prefixes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "title" VARCHAR(150) NOT NULL,
    "message" TEXT NOT NULL,
    "is_read" BOOLEAN DEFAULT false,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "periods" (
    "id" INTEGER NOT NULL,
    "start_time" TIME(6),
    "end_time" TIME(6),
    "period_name" VARCHAR,

    CONSTRAINT "periods_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "project_activities" (
    "id" SERIAL NOT NULL,
    "project_id" INTEGER NOT NULL,
    "activity_name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "responsible_teacher_id" INTEGER,
    "start_date" DATE,
    "end_date" DATE,
    "planned_budget" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "status" VARCHAR(30) NOT NULL DEFAULT 'PLANNING',
    "order_number" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "project_activities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "project_approvals" (
    "id" SERIAL NOT NULL,
    "project_id" INTEGER NOT NULL,
    "action" VARCHAR(30) NOT NULL,
    "action_by" INTEGER,
    "note" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "project_approvals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "project_budgets" (
    "id" SERIAL NOT NULL,
    "project_id" INTEGER NOT NULL,
    "semester_id" INTEGER NOT NULL,
    "expense_category_id" INTEGER,
    "planned_amount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "note" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "project_budgets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "project_documents" (
    "id" SERIAL NOT NULL,
    "project_id" INTEGER NOT NULL,
    "document_type" VARCHAR(50) NOT NULL DEFAULT 'OTHER',
    "file_name" VARCHAR(255) NOT NULL,
    "file_path" VARCHAR(500) NOT NULL,
    "mime_type" VARCHAR(100),
    "file_size" INTEGER,
    "uploaded_by" INTEGER,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "project_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "project_expenses" (
    "id" SERIAL NOT NULL,
    "project_id" INTEGER NOT NULL,
    "expense_date" DATE NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "receipt_number" VARCHAR(100),
    "recorded_by" INTEGER,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "expense_category_id" INTEGER,
    "semester_id" INTEGER,
    "payment_method" "enum_peyment_method",
    "receipt_file" VARCHAR(255),
    "updated_at" TIMESTAMP(6),
    "note" TEXT,
    "vendor_name" VARCHAR(255),
    "disbursement_number" VARCHAR(100),
    "status" VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    "approved_by" INTEGER,
    "approved_at" TIMESTAMP(6),
    "rejection_reason" TEXT,

    CONSTRAINT "project_expenses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "project_indicators" (
    "id" SERIAL NOT NULL,
    "project_id" INTEGER NOT NULL,
    "indicator_name" VARCHAR(255) NOT NULL,
    "target_value" VARCHAR(100),
    "actual_value" VARCHAR(100),
    "unit" VARCHAR(50),
    "result_note" TEXT,
    "order_number" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "project_indicators_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "project_objectives" (
    "id" SERIAL NOT NULL,
    "project_id" INTEGER NOT NULL,
    "objective_text" TEXT NOT NULL,
    "order_number" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "project_objectives_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "project_types" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "project_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "projects" (
    "id" SERIAL NOT NULL,
    "project_code" VARCHAR(50),
    "project_name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "teacher_id" INTEGER,
    "start_date" DATE,
    "end_date" DATE,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "department_id" INTEGER,
    "budget_type_id" INTEGER,
    "allocated_budget" DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    "project_type_id" INTEGER,
    "academic_year_id" INTEGER,
    "status" VARCHAR(30) NOT NULL DEFAULT 'PLANNING',
    "rationale" TEXT,
    "expected_outcomes" TEXT,
    "target_participants" INTEGER,
    "created_by" INTEGER,
    "submitted_by" INTEGER,
    "approved_by" INTEGER,
    "submitted_at" TIMESTAMP(6),
    "approved_at" TIMESTAMP(6),
    "rejection_reason" TEXT,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "projects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" SERIAL NOT NULL,
    "role_name" VARCHAR(50) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rooms" (
    "id" INTEGER NOT NULL,
    "room_name" VARCHAR(50),
    "capacity" INTEGER,
    "floor" INTEGER,
    "building_id" INTEGER,

    CONSTRAINT "rooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "semesters" (
    "id" SERIAL NOT NULL,
    "academic_year_id" INTEGER NOT NULL,
    "semester_number" INTEGER NOT NULL,
    "start_date" DATE,
    "end_date" DATE,
    "is_active" BOOLEAN DEFAULT false,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "semesters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "student_daily_health_records" (
    "id" SERIAL NOT NULL,
    "student_id" INTEGER NOT NULL,
    "semester_id" INTEGER NOT NULL,
    "record_date" DATE NOT NULL,
    "drinks_milk" BOOLEAN DEFAULT false,
    "brushes_teeth" BOOLEAN DEFAULT false,
    "recorded_by" INTEGER,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "student_daily_health_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "student_scores" (
    "id" SERIAL NOT NULL,
    "assessment_item_id" INTEGER NOT NULL,
    "score" DECIMAL(5,2) DEFAULT 0.00,
    "is_missing" BOOLEAN DEFAULT false,
    "remark" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "is_passed" BOOLEAN,
    "student_id" INTEGER,

    CONSTRAINT "student_scores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "student_statuses" (
    "id" SERIAL NOT NULL,
    "status_name" "enum_student_status",

    CONSTRAINT "student_statuses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "students" (
    "id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "student_code" VARCHAR(20) NOT NULL,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100) NOT NULL,
    "date_of_birth" DATE,
    "phone" VARCHAR(20),
    "address" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "prefix_id" INTEGER,
    "status_id" INTEGER,
    "gender_id" INTEGER,
    "enrollment_date" DATE,
    "admission_year_id" INTEGER,
    "student_national_id" VARCHAR(13),
    "parent_name" VARCHAR(150),
    "parent_phone" VARCHAR(20),

    CONSTRAINT "students_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subject_categories" (
    "id" SERIAL NOT NULL,
    "category_name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "evaluation_type_id" INTEGER DEFAULT 1,

    CONSTRAINT "subject_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subjects" (
    "id" INTEGER NOT NULL,
    "subject_code" VARCHAR(20) NOT NULL,
    "subject_name" VARCHAR(150) NOT NULL,
    "credit" DECIMAL(3,1) DEFAULT 1.0,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "learning_subject_group_id" INTEGER,
    "subject_categories_id" INTEGER,
    "level_id" INTEGER,
    "grade_scale_group_id" INTEGER,

    CONSTRAINT "subjects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "target_types" (
    "code" VARCHAR(30) NOT NULL,
    "display_name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "is_active" BOOLEAN DEFAULT true,
    "input_type" VARCHAR(50) DEFAULT 'none',
    "data_source_api" VARCHAR(255),

    CONSTRAINT "target_types_pkey" PRIMARY KEY ("code")
);

-- CreateTable
CREATE TABLE "teacher_positions" (
    "id" SERIAL NOT NULL,
    "title" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "teacher_positions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "teachers" (
    "id" INTEGER NOT NULL,
    "user_id" INTEGER,
    "teacher_code" VARCHAR(20) NOT NULL,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100) NOT NULL,
    "phone" VARCHAR(20),
    "hire_date" DATE,
    "status" VARCHAR(20) DEFAULT 'active',
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "position_id" INTEGER,
    "prefix_id" INTEGER,
    "department_id" INTEGER,
    "employment_type_id" INTEGER,
    "birth_date" DATE,
    "salary" DECIMAL(10,2),
    "blood_type" VARCHAR(5),
    "teacher_national_id" VARCHAR(13),

    CONSTRAINT "teachers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "username" VARCHAR(50) NOT NULL,
    "email" VARCHAR(100),
    "password_hash" TEXT,
    "role_id" INTEGER NOT NULL,
    "is_active" BOOLEAN DEFAULT true,
    "last_login" TIMESTAMP(6),
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "academic_year_name_unique" ON "academic_years"("id" ASC, "year_name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "academic_years_year_name_key" ON "academic_years"("year_name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "attendance_records_student_id_check_date_key" ON "attendance_records"("student_id" ASC, "check_date" ASC);

-- CreateIndex
CREATE INDEX "idx_behav_rec_semester" ON "behavior_records"("semester_id" ASC);

-- CreateIndex
CREATE INDEX "idx_behav_rec_status" ON "behavior_records"("status" ASC);

-- CreateIndex
CREATE INDEX "idx_behav_rec_student" ON "behavior_records"("student_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "budget_types_name_unique" ON "budget_types"("name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "buildings_building_name_key" ON "buildings"("building_name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "uq_schedule" ON "class_schedule"("classroom_id" ASC, "semester_id" ASC, "day_of_week_id" ASC, "period_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "uq_classroom_year" ON "classroom_assignments"("classroom_id" ASC, "academic_year_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "uq_teacher_year" ON "classroom_assignments"("teacher_id" ASC, "academic_year_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "classroom_students_classroom_id_student_id_academic_year_key" ON "classroom_students"("classroom_id" ASC, "student_id" ASC, "academic_year_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "classrooms_unique_1" ON "classrooms"("grade_level_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "departments_department_name_key" ON "departments"("department_name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "evaluation_question_types_code_name_key" ON "evaluation_question_types"("code_name" ASC);

-- CreateIndex
CREATE INDEX "idx_eval_resp_evaluator" ON "evaluation_responses"("evaluator_user_id" ASC);

-- CreateIndex
CREATE INDEX "idx_eval_resp_semester" ON "evaluation_responses"("semester_id" ASC);

-- CreateIndex
CREATE INDEX "idx_eval_resp_subject" ON "evaluation_responses"("target_subject_id" ASC);

-- CreateIndex
CREATE INDEX "idx_eval_resp_teacher" ON "evaluation_responses"("target_teacher_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "expense_categories_name_unique" ON "expense_categories"("name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "final_grades_student_id_subject_id_semester_id_key" ON "final_grades"("student_id" ASC, "subject_id" ASC, "semester_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "grade_category_types_type_name_key" ON "grade_category_types"("type_name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "learning_subject_groups_name_key" ON "learning_subject_groups"("group_name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "name_prefixes_prefix_name_key" ON "name_prefixes"("prefix_name" ASC);

-- CreateIndex
CREATE INDEX "idx_project_activities_project" ON "project_activities"("project_id" ASC);

-- CreateIndex
CREATE INDEX "idx_project_budgets_project" ON "project_budgets"("project_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "project_budgets_unique_plan" ON "project_budgets"("project_id" ASC, "semester_id" ASC, "expense_category_id" ASC);

-- CreateIndex
CREATE INDEX "idx_project_documents_project" ON "project_documents"("project_id" ASC);

-- CreateIndex
CREATE INDEX "idx_project_expenses_project_semester" ON "project_expenses"("project_id" ASC, "semester_id" ASC);

-- CreateIndex
CREATE INDEX "idx_project_indicators_project" ON "project_indicators"("project_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "project_types_name_unique" ON "project_types"("name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "projects_project_code_key" ON "projects"("project_code" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "projects_project_code_key1" ON "projects"("project_code" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "roles"("role_name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "rooms_name_building_unique" ON "rooms"("room_name" ASC, "building_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "semesters_academic_year_id_semester_number_key" ON "semesters"("academic_year_id" ASC, "semester_number" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "unique_student_daily_record" ON "student_daily_health_records"("student_id" ASC, "record_date" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "student_scores_student_id_assessment_item_id_key" ON "student_scores"("student_id" ASC, "assessment_item_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "students_national_id_unique" ON "students"("student_national_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "students_student_code_key" ON "students"("student_code" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "students_user_id_key" ON "students"("user_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "subject_categories_category_name_key" ON "subject_categories"("category_name" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "subjects_subject_code_key" ON "subjects"("subject_code" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "teacher_positions_title_key" ON "teacher_positions"("title" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "teachers_national_id_unique" ON "teachers"("teacher_national_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "teachers_teacher_code_unique" ON "teachers"("teacher_code" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "teachers_user_id_key" ON "teachers"("user_id" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_unique" ON "users"("email" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "users_username_unique" ON "users"("username" ASC);

-- AddForeignKey
ALTER TABLE "assessment_items" ADD CONSTRAINT "assessment_items_grade_category_id_fkey" FOREIGN KEY ("grade_category_id") REFERENCES "grade_categories"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "attendance_status"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "behavior_records" ADD CONSTRAINT "behavior_records_behavior_type_id_fkey" FOREIGN KEY ("behavior_type_id") REFERENCES "behavior_types"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "behavior_records" ADD CONSTRAINT "behavior_records_semester_id_fkey" FOREIGN KEY ("semester_id") REFERENCES "semesters"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "behavior_records" ADD CONSTRAINT "behavior_records_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "class_schedule" ADD CONSTRAINT "fk_schedule_classroom" FOREIGN KEY ("classroom_id") REFERENCES "classrooms"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "class_schedule" ADD CONSTRAINT "fk_schedule_day" FOREIGN KEY ("day_of_week_id") REFERENCES "day_of_weeks"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "class_schedule" ADD CONSTRAINT "fk_schedule_period" FOREIGN KEY ("period_id") REFERENCES "periods"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "class_schedule" ADD CONSTRAINT "fk_schedule_semester" FOREIGN KEY ("semester_id") REFERENCES "semesters"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "class_schedule" ADD CONSTRAINT "fk_schedule_subject" FOREIGN KEY ("subject_id") REFERENCES "subjects"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "classroom_assignments" ADD CONSTRAINT "fk_academic_year_id" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "classroom_assignments" ADD CONSTRAINT "fk_classrooms_id" FOREIGN KEY ("classroom_id") REFERENCES "classrooms"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "classroom_assignments" ADD CONSTRAINT "fk_teacher_id" FOREIGN KEY ("teacher_id") REFERENCES "teachers"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "classroom_students" ADD CONSTRAINT "classroom_students_classroom_id_fkey" FOREIGN KEY ("classroom_id") REFERENCES "classrooms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "classroom_students" ADD CONSTRAINT "classroom_students_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "classroom_students" ADD CONSTRAINT "fk_classroom_student_academic_year" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "classrooms" ADD CONSTRAINT "fk_grade_level_idalter" FOREIGN KEY ("grade_level_id") REFERENCES "grade_level"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_answers" ADD CONSTRAINT "evaluation_answers_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "evaluation_questions"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_categories" ADD CONSTRAINT "evaluation_categories_evaluator_role_id_fkey" FOREIGN KEY ("evaluator_role_id") REFERENCES "roles"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_choices" ADD CONSTRAINT "evaluation_choices_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "evaluation_questions"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_forms" ADD CONSTRAINT "evaluation_forms_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "evaluation_categories"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_questions" ADD CONSTRAINT "evaluation_questions_question_type_id_fkey" FOREIGN KEY ("question_type_id") REFERENCES "evaluation_question_types"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_questions" ADD CONSTRAINT "evaluation_questions_scale_type_id_fkey" FOREIGN KEY ("scale_type_id") REFERENCES "evaluation_scale_types"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_questions" ADD CONSTRAINT "evaluation_questions_section_id_fkey" FOREIGN KEY ("section_id") REFERENCES "evaluation_sections"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_responses" ADD CONSTRAINT "evaluation_responses_evaluation_users_id_fkey" FOREIGN KEY ("evaluator_user_id") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_responses" ADD CONSTRAINT "evaluation_responses_form_id_fkey" FOREIGN KEY ("form_id") REFERENCES "evaluation_forms"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_responses" ADD CONSTRAINT "evaluation_responses_semester_id_fkey" FOREIGN KEY ("semester_id") REFERENCES "semesters"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_scale_items" ADD CONSTRAINT "evaluation_scale_items_scale_type_id_fkey" FOREIGN KEY ("scale_type_id") REFERENCES "evaluation_scale_types"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_schedules" ADD CONSTRAINT "evaluation_schedules_form_id_fkey" FOREIGN KEY ("form_id") REFERENCES "evaluation_forms"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_schedules" ADD CONSTRAINT "evaluation_schedules_semester_id_fkey" FOREIGN KEY ("semester_id") REFERENCES "semesters"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "evaluation_sections" ADD CONSTRAINT "evaluation_sections_form_id_fkey" FOREIGN KEY ("form_id") REFERENCES "evaluation_forms"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "event_targets" ADD CONSTRAINT "event_targets_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "event_targets" ADD CONSTRAINT "fk_target_type_code" FOREIGN KEY ("target_type") REFERENCES "target_types"("code") ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "event_semester_id_fkey" FOREIGN KEY ("semester_id") REFERENCES "semesters"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_event_type_id_fkey" FOREIGN KEY ("event_type_id") REFERENCES "event_types"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "final_grades" ADD CONSTRAINT "fk_final_grade_semester" FOREIGN KEY ("student_id") REFERENCES "semesters"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "final_grades" ADD CONSTRAINT "fk_final_grade_subject" FOREIGN KEY ("subject_id") REFERENCES "subjects"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "final_grades" ADD CONSTRAINT "fk_final_grades_calculated_by_teacher" FOREIGN KEY ("calculated_by") REFERENCES "teachers"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "final_grades" ADD CONSTRAINT "fk_final_grades_student" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "final_grades" ADD CONSTRAINT "grade_scale_id" FOREIGN KEY ("grade_scale_id") REFERENCES "grade_scales"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "grade_categories" ADD CONSTRAINT "grade_categories_category_type_id_fkey" FOREIGN KEY ("category_type_id") REFERENCES "grade_category_types"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "grade_categories" ADD CONSTRAINT "grade_categories_teaching_assignment_id_fkey" FOREIGN KEY ("classroom_assignment_id") REFERENCES "classroom_assignments"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "grade_scale_groups" ADD CONSTRAINT "fk_grade_scale_group_evaluation" FOREIGN KEY ("evaluation_type_id") REFERENCES "evaluation_types"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "grade_scales" ADD CONSTRAINT "grade_scales_grade_scale_group_id_fkey" FOREIGN KEY ("grade_scale_group_id") REFERENCES "grade_scale_groups"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "health_checkup_records" ADD CONSTRAINT "health_checkup_records_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_activities" ADD CONSTRAINT "project_activities_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_activities" ADD CONSTRAINT "project_activities_responsible_teacher_id_fkey" FOREIGN KEY ("responsible_teacher_id") REFERENCES "teachers"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_approvals" ADD CONSTRAINT "project_approvals_action_by_fkey" FOREIGN KEY ("action_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_approvals" ADD CONSTRAINT "project_approvals_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_budgets" ADD CONSTRAINT "project_budgets_expense_category_id_fkey" FOREIGN KEY ("expense_category_id") REFERENCES "expense_categories"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_budgets" ADD CONSTRAINT "project_budgets_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_budgets" ADD CONSTRAINT "project_budgets_semester_id_fkey" FOREIGN KEY ("semester_id") REFERENCES "semesters"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_documents" ADD CONSTRAINT "project_documents_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_documents" ADD CONSTRAINT "project_documents_uploaded_by_fkey" FOREIGN KEY ("uploaded_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_expenses" ADD CONSTRAINT "fk_project_expenses_semester" FOREIGN KEY ("semester_id") REFERENCES "semesters"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_expenses" ADD CONSTRAINT "fk_project_expenses_user" FOREIGN KEY ("recorded_by") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_expenses" ADD CONSTRAINT "project_expenses_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_expenses" ADD CONSTRAINT "project_expenses_expense_category_id_fkey" FOREIGN KEY ("expense_category_id") REFERENCES "expense_categories"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_expenses" ADD CONSTRAINT "project_expenses_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_indicators" ADD CONSTRAINT "project_indicators_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_objectives" ADD CONSTRAINT "project_objectives_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_budget_id_fkey" FOREIGN KEY ("budget_type_id") REFERENCES "budget_types"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_project_type_id_fkey" FOREIGN KEY ("project_type_id") REFERENCES "project_types"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_submitted_by_fkey" FOREIGN KEY ("submitted_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "rooms" ADD CONSTRAINT "rooms_building_id_fkey" FOREIGN KEY ("building_id") REFERENCES "buildings"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "semesters" ADD CONSTRAINT "semesters_academic_year_id_fkey" FOREIGN KEY ("academic_year_id") REFERENCES "academic_years"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "student_daily_health_records" ADD CONSTRAINT "fk_semester" FOREIGN KEY ("semester_id") REFERENCES "semesters"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "student_daily_health_records" ADD CONSTRAINT "fk_student" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "student_scores" ADD CONSTRAINT "fk_student_scores_student" FOREIGN KEY ("student_id") REFERENCES "students"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "student_scores" ADD CONSTRAINT "student_scores_assessment_item_id_fkey" FOREIGN KEY ("assessment_item_id") REFERENCES "assessment_items"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "fk_student_admission_year_id_year" FOREIGN KEY ("admission_year_id") REFERENCES "academic_years"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_gender_id_fkey" FOREIGN KEY ("gender_id") REFERENCES "genders"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_prefix_id_fkey" FOREIGN KEY ("prefix_id") REFERENCES "name_prefixes"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "student_statuses"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "subject_categories" ADD CONSTRAINT "fk_subject_category_evaluations" FOREIGN KEY ("evaluation_type_id") REFERENCES "evaluation_types"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "subjects" ADD CONSTRAINT "fk_subject_grade_scale_group" FOREIGN KEY ("grade_scale_group_id") REFERENCES "grade_scale_groups"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "subjects" ADD CONSTRAINT "fk_subjects_categories" FOREIGN KEY ("subject_categories_id") REFERENCES "subject_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subjects" ADD CONSTRAINT "subjects_learning_subject_group_id_fkey" FOREIGN KEY ("learning_subject_group_id") REFERENCES "learning_subject_groups"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "teachers" ADD CONSTRAINT "fk_teacher_employment_types" FOREIGN KEY ("employment_type_id") REFERENCES "employment_types"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "teachers" ADD CONSTRAINT "teachers_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "teachers" ADD CONSTRAINT "teachers_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "teacher_positions"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "teachers" ADD CONSTRAINT "teachers_prefix_id_fkey" FOREIGN KEY ("prefix_id") REFERENCES "name_prefixes"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "teachers" ADD CONSTRAINT "teachers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Prisma does not emit PostgreSQL CHECK constraints from introspection.
-- Keep the constraints from the baseline database so a fresh database behaves identically.
ALTER TABLE "behavior_records" ADD CONSTRAINT "check_behavior_record_status"
  CHECK ("status" IN ('PENDING', 'APPROVED', 'REJECTED'));
ALTER TABLE "evaluation_responses" ADD CONSTRAINT "check_evaluation_status"
  CHECK ("status" IN ('DRAFT', 'COMPLETED'));
ALTER TABLE "events" ADD CONSTRAINT "events_visibility_check"
  CHECK ("visibility" IN ('public', 'restricted', 'all', 'grade_level', 'classroom', 'teaching_assignment', 'learning_group'));
ALTER TABLE "grade_categories" ADD CONSTRAINT "grade_categories_weight_percent_check"
  CHECK ("weight_percent" >= 0);
ALTER TABLE "grade_scales" ADD CONSTRAINT "grade_scales_check"
  CHECK ("min_score" <= "max_score");
ALTER TABLE "project_activities" ADD CONSTRAINT "project_activities_status_check"
  CHECK ("status" IN ('PLANNING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'));
ALTER TABLE "project_approvals" ADD CONSTRAINT "project_approvals_action_check"
  CHECK ("action" IN ('SUBMITTED', 'APPROVED', 'REJECTED', 'RETURNED', 'CANCELLED'));
ALTER TABLE "project_budgets" ADD CONSTRAINT "project_budgets_amount_check"
  CHECK ("planned_amount" >= 0);
ALTER TABLE "project_expenses" ADD CONSTRAINT "project_expenses_amount_check"
  CHECK ("amount" > 0);
ALTER TABLE "project_expenses" ADD CONSTRAINT "project_expenses_status_check"
  CHECK ("status" IN ('PENDING', 'APPROVED', 'REJECTED', 'PAID', 'CANCELLED'));
ALTER TABLE "projects" ADD CONSTRAINT "projects_status_check"
  CHECK ("status" IN ('PLANNING', 'PENDING_APPROVAL', 'APPROVED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'REJECTED'));
