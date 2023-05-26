import { Column, Entity, PrimaryGeneratedColumn, OneToMany, JoinColumn } from "typeorm";

@Entity()
export class Person{
	@PrimaryGeneratedColumn()
	public id!: number;

	@Column()
	public authId: number;

	@Column()
	public name: string;

	@Column()
	public surname: string;

	@Column()
	public occupation: string;

	@Column()
	public avatarUrl: number;
}
