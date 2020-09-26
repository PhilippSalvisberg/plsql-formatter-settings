-- based on https://github.com/Trivadis/plsql-and-sql-coding-guidelines/blob/main/docs/3-coding-style/coding-style.md#example

CREATE OR REPLACE PROCEDURE set_salary(
   in_employee_id IN employees.employee_id%TYPE
) IS
   CURSOR c_employees(
      p_employee_id IN employees.employee_id%TYPE
   ) IS 
      SELECT last_name, first_name, salary
        FROM employees
       WHERE employee_id = p_employee_id
       ORDER BY last_name, first_name;
   r_employee   c_employees%ROWTYPE;
   l_new_salary employees.salary%TYPE;
BEGIN
   OPEN c_employees(p_employee_id => in_employee_id);
   FETCH c_employees INTO r_employee;
   CLOSE c_employees;
   new_salary(
      in_employee_id => in_employee_id,
      out_salary     => l_new_salary
   );
   -- Check whether salary has changed
   IF r_employee.salary <> l_new_salary THEN
      UPDATE employees
         SET salary = l_new_salary
       WHERE employee_id = in_employee_id;
   END IF;
END set_salary;
/
