import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Person } from './persons.entity';

@Injectable()
export class PersonsService {
	@InjectRepository(Person)
	private readonly repository: Repository<Person>;

	public findPersons(): Promise<Person[]> {
		return this.repository.find();
	}

	public updatePersonById(id: number, person: Person): Boolean {
		this.repository.update(id, person);
		return true;
	}
}
