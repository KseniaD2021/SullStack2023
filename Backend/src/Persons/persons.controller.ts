import { Controller, Get, Param, Put, Body } from '@nestjs/common';
import { PersonsService } from './persons.service';
import { Person } from './persons.entity';

@Controller('')
export class PersonsController {
	public constructor(
		private readonly personsService: PersonsService)
	{ }

	@Get('person/:id')
	public async getPersonById(@Param('id') id: number): Promise<Person> {
		return (await this.personsService.findPersons()).find(person => person.authId == id);
	}

	@Put('person/:id')
	public async updatePersonById(@Param('id') id: number, @Body() person: Person): Promise<Boolean> {
		return this.personsService.updatePersonById(id, person);
	}
}
