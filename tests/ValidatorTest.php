<?php

use PHPUnit\Framework\TestCase;

require_once __DIR__ . '/../config/Validator.php';

class ValidatorTest extends TestCase
{
    private $validator;

    protected function setUp(): void
    {
        $this->validator = new Validator();
    }

    public function testEmailValidation()
    {
        $this->assertTrue($this->validator->email('test@example.com'));
        $this->assertFalse($this->validator->email('invalid-email'));
        $this->assertFalse($this->validator->email(''));
    }

    public function testPasswordValidation()
    {
        // Password must have min 8 chars, 1 uppercase, 1 number
        $this->assertTrue($this->validator->password('SecurePass123'));
        $this->assertFalse($this->validator->password('weak'));
        $this->assertFalse($this->validator->password('nouppercaseornum'));
        $this->assertFalse($this->validator->password(''));
    }

    public function testStringValidation()
    {
        $this->assertTrue($this->validator->string('Valid String', 'Name', 1, 100));
        $this->assertFalse($this->validator->string('', 'Name', 1, 100));
        $this->assertFalse($this->validator->string('Tool Long String Name Here', 'Name', 1, 10));
    }

    public function testRequiredValidation()
    {
        $this->assertTrue($this->validator->required('value'));
        $this->assertFalse($this->validator->required(''));
        $this->assertFalse($this->validator->required('   '));
    }

    public function testNumericValidation()
    {
        $this->assertTrue($this->validator->numeric(123));
        $this->assertTrue($this->validator->numeric('456'));
        $this->assertFalse($this->validator->numeric('abc'));
    }

    public function testInValidation()
    {
        $allowed = ['Year 1', 'Year 2', 'Year 3'];
        $this->assertTrue($this->validator->in('Year 1', $allowed));
        $this->assertFalse($this->validator->in('Year 5', $allowed));
    }

    public function testSanitizeInput()
    {
        $this->assertEquals(
            'test@example.com',
            $this->validator->sanitizeInput('test@example.com', 'email')
        );

        $this->assertEquals(
            'Hello World',
            $this->validator->sanitizeInput('<script>Hello World</script>', 'string')
        );
    }

    public function testErrorCollection()
    {
        $validator = new Validator();
        $validator->email('invalid-email');
        $validator->password('weak');

        $this->assertTrue($validator->hasErrors());
        $this->assertCount(2, $validator->getErrors());
    }
}
